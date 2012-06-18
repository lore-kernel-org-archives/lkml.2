Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281Ab2FRUY3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 16:24:29 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:36558 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238Ab2FRUY2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 16:24:28 -0400
MIME-Version: 1.0
In-Reply-To: <20120521093937.GM30755@b20223-02.ap.freescale.net>
References: <1336870794-6351-2-git-send-email-richard.zhao@freescale.com>
 <20120514035137.GB20367@S2100-06.ap.freescale.net> <20120514080835.GB31985@opensource.wolfsonmicro.com>
 <4FB0C9D4.2060409@linaro.org> <20120514094357.GF20367@S2100-06.ap.freescale.net>
 <4FB10821.4000004@linaro.org> <20120514135035.GC29393@b20223-02.ap.freescale.net>
 <20120518095932.GI30755@b20223-02.ap.freescale.net> <20120521041355.GF5810@S2100-06.ap.freescale.net>
 <4FBA0A9A.8040901@linaro.org> <20120521093937.GM30755@b20223-02.ap.freescale.net>
From: Rob Lee <rob.lee@linaro.org>
Date: Mon, 18 Jun 2012 15:23:45 -0500
Message-ID: <CAMXH7KF4qegQkQ3mS2=U=VBXZHJfiU2GiozRHgkP3OVX0Q+thQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] mfd: anatop: permit adata be NULL when access register
To: Richard Zhao <richard.zhao@freescale.com>, sameo@linux.intel.com
Cc: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>,
        Shawn Guo <shawn.guo@freescale.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, shawn.guo@linaro.org,
        Richard Zhao <richard.zhao@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

What is the status of this patch?

Thanks,
Rob

On Mon, May 21, 2012 at 4:39 AM, Richard Zhao
<richard.zhao@freescale.com> wrote:
> On Mon, May 21, 2012 at 05:27:54PM +0800, Ying-Chun Liu (PaulLiu) wrote:
>> (2012年05月21日 12:13), Shawn Guo wrote:
>> > On Fri, May 18, 2012 at 05:59:32PM +0800, Richard Zhao wrote:
>> >> Guys, we need to draw conclusion.
>> >> I think current patch keep some how compatible with multi-anatop.
>> >> It's ok.
>> >>
>> > I'm fine with that.
>> >
>> Yes. It is good for me.
>>
> So, Sameo, could you pick the patch.
>
> Thanks
> Richard
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
