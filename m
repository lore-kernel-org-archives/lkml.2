Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756921Ab2DTAVu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 20:21:50 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:45178 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753934Ab2DTAVr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 20:21:47 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1204200023500.2110@axis700.grange>
References: <20120419020136.GB3443@windriver.com> <878vhrjs6x.fsf@laptop.org> <Pine.LNX.4.64.1204200023500.2110@axis700.grange>
From: Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Thu, 19 Apr 2012 20:21:15 -0400
X-Google-Sender-Auth: ioGlDeZ6nFbV66m_GxeeuqH7d00
Message-ID: <CAP=VYLpQ7zMReYn-6OoZUnok7dGKS5C+Fdb2BU2FHZTM5wvpBg@mail.gmail.com>
Subject: Re: linux-next: triage for April 18, 2012
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Chris Ball <cjb@laptop.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2012 at 6:24 PM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> On Thu, 19 Apr 2012, Chris Ball wrote:
>
>> Hi,
>>
>> On Wed, Apr 18 2012, Paul Gortmaker wrote:
>> > ARM:mackerel_defconfig,ag5evm_defconfig
>> >     when:   Apr 19 (possibly earlier?)
>> >     why:    pfc-sh7372.c: undefined reference to `mmc_detect_change'
>> >     why:    pfc-sh73a0.c: undefined reference to `mmc_detect_change'
>> >     status:
>> >     fix:
>> >     ref:    http://kisskb.ellerman.id.au/kisskb/buildresult/6131930/
>> >     ref:    http://kisskb.ellerman.id.au/kisskb/buildresult/6131908/
>>
>> Adding Guennadi and Magnus to CC for this error (which is coming from
>> tmio_mmc_cd_wakeup).
>
> ...waiting for these patches to make it in:

Thanks for the update, I'll add those links while we are waiting.

P.

>
> http://article.gmane.org/gmane.linux.ports.sh.devel/14412
> http://article.gmane.org/gmane.linux.ports.sh.devel/14413
>
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-next" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
