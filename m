Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014Ab0C0VbW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 17:31:22 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:34847 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980Ab0C0VbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 17:31:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=BZY6WMWuLKHPMJ13OZIoJ7ZRjxLvS3f7hPIgkyuRXHW+mhrQr5rKujjj+rnCaUmVDc
         JqYbtcqkHxb8UPwqWzkg9Q1HFdyomjcgC/mHrMHgjjwyyQUADkHmETU6yHGf53+WwcNB
         wK0oqu7fFXQ/wD9+Frg1QKfPFzF6xtN0oFYHA=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Norbert Preining <preining@logic.at>, jbarnes@virtuousgeek.org,
       bjorn.helgaas@hp.com, airlied@linux.ie, eric@anholt.net
Subject: Re: intel graphic card hanging (Hangcheck timer elapsed... GPU hung)
Date: Sat, 27 Mar 2010 22:31:15 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc2; KDE/4.3.4; i686; ; )
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net
References: <20100327161104.GA12043@gamma.logic.tuwien.ac.at>
In-Reply-To: <20100327161104.GA12043@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201003272231.15897.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On sobota, 27 marca 2010 o 17:11:05 Norbert Preining wrote:
> Dear all,
> 
> (please Cc)

[Added more CCs]

Similar:
http://marc.info/?l=linux-kernel&m=126954749618319&w=2

> 
> I am running 2.6.34-rc2 + git 01e7770 commit (yesterday) with KMS on
>  Debian/sid: xserver-xorg: 7.5+5
> video-intel: 2.9.1-3
> 
> Running D2X-xl (self compiled) (descent2 open source code) X suddenly died,
> and after that gdm could not be restarted because after a few secs
> it went dead again.
> 
> In the logs I see:
> kernel: [ 2486.341227] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer
>  elapsed... GPU hung kernel: [ 2486.341240] render error detected, EIR:
>  0x00000000
> kernel: [ 2486.341278] [drm:i915_do_wait_request] *ERROR*
>  i915_do_wait_request returns -5 (awaiting 113671 at 113604) kernel: [
>  2486.669008] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer
>  elapsed... GPU hung kernel: [ 2486.669012] render error detected, EIR:
>  0x00000000
> kernel: [ 2486.669522] [drm:i915_do_wait_request] *ERROR*
>  i915_do_wait_request returns -5 (awaiting 113672 at 113604) kernel: [
>  2487.524230] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer
>  elapsed... GPU hung kernel: [ 2487.524243] render error detected, EIR:
>  0x00000000
> kernel: [ 2487.524284] [drm:i915_do_wait_request] *ERROR*
>  i915_do_wait_request returns -5 (awaiting 113673 at 113604) kernel: [
>  2487.912237] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer
>  elapsed... GPU hung kernel: [ 2487.916175] render error detected, EIR:
>  0x00000000
> kernel: [ 2487.920137] [drm:i915_do_wait_request] *ERROR*
>  i915_do_wait_request returns -5 (awaiting 113674 at 113604)
> 
> Stopping gdm and restarting didn't help to get the graphics card back to
>  normal.
> 
> If you have any ideas how to fix/track/debug that please let me know,
> same if you need more information.
> 
> Best wishes
> 
> Norbert
> ------------------------------------------------------------------------
> Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
> JAIST, Japan            TU Wien, Austria           Debian TeX Task Force
> DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
> ------------------------------------------------------------------------
> HUCKNALL (vb.)
> To crouch upwards: as in the movement of a seated person's feet and
> legs made in order to allow a cleaner's hoover to pass beneath them.
> 			--- Douglas Adams, The Meaning of Liff
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
