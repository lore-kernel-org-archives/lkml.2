Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757515Ab0FOL7q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 07:59:46 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:46978 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752891Ab0FOL7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 07:59:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=rXTRFzqbHzLihxjx9WhOsMrRFhtdrBsp0om/lQ8YPMddQZ99VjSqPEjEEtSp4Edn8o
         nuAYApd4K/tFA9hFUDRavGAplPDQV+TFKazQOsvKDWLqcfbX4B9JZdk3YtKs2V8r2D3I
         ldRUqt1IwVvIxqwT1enAtOSjKncoo6HvcE5gY=
Subject: Re: [Nouveau] [BUG ?] Nouveau driver on 330M GT
From: Ben Skeggs <skeggsb@gmail.com>
Reply-To: skeggsb@gmail.com
To: Eric Lacombe <goretux@gmail.com>
Cc: Younes Manton <younes.m@gmail.com>, Dave Airlie <airlied@linux.ie>,
       nouveau@lists.freedesktop.org, linux-kernel@vger.kernel.org
In-Reply-To: <201006151318.08619.goretux@gmail.com>
References: <201006111052.29187.goretux@gmail.com>
	 <AANLkTilGym6lbGnSKuahBvIAT7a2Wt405i_XZtd7FFwd@mail.gmail.com>
	 <201006151318.08619.goretux@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Jun 2010 21:31:03 +1000
Message-ID: <1276601463.2526.4.camel@nisroch>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 (2.30.1.2-8.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-15 at 13:18 +0200, Eric Lacombe wrote:
> > Please make sure nvidiafb is not loaded. If you still have issues
> > after making sure that nouveau is the only kernel module running for
> > this device please attach a full log.
> 
> nvidiafb is not loaded.
> 
> I've attached the full log. And here are the drm lines of the log :
> 
> [drm] nouveau 0000:01:00.0: Detected an NV50 generation card (0x0a5580a2)
> [drm] nouveau 0000:01:00.0: Attempting to load BIOS image from PRAMIN
> [drm] nouveau 0000:01:00.0: ... BIOS signature not found
> [drm] nouveau 0000:01:00.0: Attempting to load BIOS image from PROM
> [drm] nouveau 0000:01:00.0: ... BIOS signature not found
> [drm] nouveau 0000:01:00.0: Attempting to load BIOS image from PCIROM
> [drm] nouveau 0000:01:00.0: ... BIOS signature not found
> [drm] nouveau 0000:01:00.0: No valid BIOS image found
Is this a system with switchable graphics (Optimus probably)?  If so,
fiddle with your BIOS options and try and enable only the NVIDIA board.

Dave has some patches that can retrieve the VBIOS image via ACPI which
may be of use to you, but I'm not sure of the status.

Ben.
> 
> Regards,
> 
> 	Eric
> _______________________________________________
> Nouveau mailing list
> Nouveau@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/nouveau


