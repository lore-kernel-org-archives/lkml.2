Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860Ab1DHHb1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 03:31:27 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63899 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902Ab1DHHbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 03:31:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=c0i8PFpEVtuFsspLWjxg4WJgX1HDk2pwbR9ktTJh1ocA/HGBiBHKqTJMuQQNzXlm1M
         cmldmPGp+zhP87wJF8HErhghcyVzxItruvJhVFl2aQTPHLxrAJVWaNqHWfwMOJgM3ZDw
         WIhUfM6uxks9dlrEOR2UrYodsQNZDnybdbZ44=
From: Marek Vasut <marek.vasut@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: 2.6.39-rc2 on zaurus: does not build, does not boot
Date: Fri, 8 Apr 2011 09:31:10 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.38-1-amd64; KDE/4.4.5; x86_64; ; )
Cc: rpurdie@rpsys.net, lenz@cs.wisc.edu,
        kernel list <linux-kernel@vger.kernel.org>, arminlitzel@web.de,
        Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
        "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>,
        dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
        utx@penguin.cz, zaurus-devel@www.linuxtogo.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>
References: <20110408062646.GA1472@ucw.cz>
In-Reply-To: <20110408062646.GA1472@ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104080931.11202.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 08 April 2011 08:26:46 Pavel Machek wrote:
> Hi!
> 
> Build fix is below. Maybe it is pending in the trees somewhere
> already...

Fix is already there, it was broken by a patch from someone recently. Thanks 
though
> 
> Boot stops just after mounting root filesystem; cursor stops
> flashing. (Any idea what goes on there?)

No idea, it works for me and doesn't hang ;-)

> 
> 								Pavel
> 
> --- ./drivers/video.ofic/pxafb.c	2011-04-06 15:19:51.000000000 +0200
> +++ ./drivers/video/pxafb.c	2011-04-07 06:20:20.000000000 +0200
> @@ -1648,7 +1648,7 @@
> 
>  	switch (val) {
>  	case CPUFREQ_PRECHANGE:
> -		if (!fbi->overlay[0].usage && !fbi->overlay[1].usage)
> +//		if (!fbi->overlay[0].usage && !fbi->overlay[1].usage)
>  			set_ctrlr_state(fbi, C_DISABLE_CLKCHANGE);
>  		break;
