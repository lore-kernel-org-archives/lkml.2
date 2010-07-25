Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751942Ab0GYRUo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 13:20:44 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44150 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab0GYRUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 13:20:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=JQmBbWsikkwNAyvMZIKpem42zj4/aVgSH8ct0Lpr0VFIWOwU69y9X8yTxxNgfJF6/3
         1T2blU1osgqV3E1Z2mwDyYGNUle5U6bQ3z9lTdcd/48aQenonJZv4v6kzyslTAfRpHJ3
         utTggF4oW5dPtUqz0HjQhQlJiQIZN1RnLeqpY=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Nils Radtke <lkml@think-future.de>
Subject: Re: [drm:i915_do_wait_request] *ERROR* i915_do_wait_request
Date: Sun, 25 Jul 2010 19:20:34 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc6; KDE/4.4.4; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <20100725155834.GJ31966@localhost>
In-Reply-To: <20100725155834.GJ31966@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201007251920.35213.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On niedziela, 25 lipca 2010 o 17:58:34 Nils Radtke wrote:
>   Hi,
> 
> I tried to run Xorg w/o dri on my notebook. Some time afterwards, a couple
> of suspend/resume cycles later, X crashed, showing ugly screens of
> horizontal and vertical stripes all over.
> 
> Is this solely due to a X/dri bug? Shouldn't it be possible to run X w/o
> dri? Or might this indicate failing hardware, maybe graphics card or
> memory corrupt?
> 
> Apr 10 15:55:28 localhost kernel: [   85.938067]
> [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed... +GPU hung
> Apr 10 15:55:28 localhost kernel: [   85.938085] render error detected,
> EIR: 0x00000000 Apr 10 15:55:28 localhost kernel: [   85.938122]
> [drm:i915_do_wait_request] *ERROR* i915_do_wait_request returns +-5
> (awaiting 2 at 1)
> 
>   Thanks,
> 
>     Nils
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

See:
https://bugzilla.kernel.org/show_bug.cgi?id=15659

Regards
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
