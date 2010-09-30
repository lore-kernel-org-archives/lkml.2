Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269Ab0I3IHA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 04:07:00 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:51657 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755072Ab0I3IG6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 04:06:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=EJo1CEf6jTaeho/L1rYE0ibWoRaVMYGjoNUeti4K4bf0KBUWR1sKuxVruI+90CqQ2l
         a13kPYK0GuTVEK8Ky2s2yeRdMiY4z2TZCrWC4xDFFyDh23G2TR1BCEa2EfWXlZESNXCu
         A6kkMySnvPVvQ2JaEMDxm9dlzgC5HfjDu6i/Y=
MIME-Version: 1.0
In-Reply-To: <20100922022047.GA3821@void.printf.net>
References: <1278658780-26397-1-git-send-email-hanumath.prasad@stericsson.com>
	<AANLkTikBdBhJeQ-t2+0echJfAxz529QZEYPJtyHUsROd@mail.gmail.com>
	<m3pqxbsibq.fsf@pullcord.laptop.org>
	<20100823204829.GB6510@console-pimps.org>
	<20100823142816.59b12253.akpm@linux-foundation.org>
	<4C739F55.8030301@nokia.com>
	<20100914112143.GA16039@void.printf.net>
	<2A3DCF3DA181AD40BDE86A3150B27B6B031606223F@dbde02.ent.ti.com>
	<20100922022047.GA3821@void.printf.net>
Date: Thu, 30 Sep 2010 16:06:57 +0800
Message-ID: <AANLkTikwdewfs_1efkga-QnB+gMUXUXKKcVNq0K_TRcQ@mail.gmail.com>
Subject: Re: [PATCH] mmc: MMC 4.4 DDR support
From: zhangfei gao <zhangfei.gao@gmail.com>
To: Chris Ball <cjb@laptop.org>
Cc: "Ghorai, Sukumar" <s-ghorai@ti.com>,
        Adrian Hunter <adrian.hunter@nokia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matt Fleming <matt@console-pimps.org>,
        Linus Walleij <linus.ml.walleij@gmail.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "STEricsson_nomadik_linux@list.st.com" 
	<STEricsson_nomadik_linux@list.st.com>,
        Hanumath Prasad <hanumath.prasad@stericsson.com>,
        Kyungmin Park <kmpark@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 22, 2010 at 10:20 AM, Chris Ball <cjb@laptop.org> wrote:
> Hi,
>
> On Mon, Sep 20, 2010 at 10:04:39AM +0530, Ghorai, Sukumar wrote:
>> Chris and all,
>> Can we plan these patches for 2.6.37 release?
>> Also let me know if I can do anything!
>
> I would like to merge this for .37, and the quirk and merge conflicts
> are not a big deal.  First, though, I'd like to see at least some of:
>
> * a reply from Hanumath to Kyungmin on the use of MMC_DDR_MODE,
>  and which host controller the submitted patch was tested on.
> * an acknowledgement/comment on Adrian's fixup patch
> * an ACK on the original+fixup patch as mergeable from Adrian
> * some explicit Tested-by: lines for the commit.

Thanks Hanumath for your patch to enable ddr mode for emmc 4.4, thanks
a lot for sharing the patch.
We have verifeid on sdhci-pxa with toshiba emmc.

Tested-by Zhangfei Gao <zhangfei.gao@marvell.com>
>
> Thanks!
>
> - Chris.
> --
> Chris Ball   <cjb@laptop.org>   <http://printf.net/>
> One Laptop Per Child
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
