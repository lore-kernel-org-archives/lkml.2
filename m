Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755723Ab0FJHCX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 03:02:23 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53349 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115Ab0FJHCV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 03:02:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=vpp+VupmFDVBh3t1gdf8JrlIExuo/OcIZf3e7hy19ipOKfD0AQhO+kJcPDVmK0JIgO
         0yrcYvmCJaVfChvEHbSiR1vNfi3/O+rfBGXgrvUWyD4t27GqaBSeCUjReMDkwY7Ukr9O
         bNH15Diqvpt1s4f7emEdcXx8glDP9mxNsvVV0=
From: Marek Vasut <marek.vasut@gmail.com>
Organization: Hack&Dev
To: linux-arm-kernel@lists.infradead.org
Subject: Re: usb gadget on zaurus and kexec
Date: Thu, 10 Jun 2010 09:00:23 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.33-2-amd64; KDE/4.4.3; x86_64; ; )
Cc: Eric Miao <eric.y.miao@gmail.com>, Cyril Hrubis <metan@ucw.cz>,
       thommycheck@gmail.com, dbaryshkov@gmail.com, pave@ucw.cz,
       arminlitzel@web.de, kernel list <linux-kernel@vger.kernel.org>,
       utx@penguin.cz, lenz@cs.wisc.edu, rpurdie@rpsys.net,
       omegamoon@gmail.com, zaurus-devel@www.linuxtogo.org
References: <20100519154618.GA26381@atrey.karlin.mff.cuni.cz> <AANLkTim49akRJK0BN_Qk1wL6e5mrdjZioDjGNWlrjUVQ@mail.gmail.com> <AANLkTilCvgvf9Ch55f878nTNTue8tHYmcrLEywsjnylY@mail.gmail.com>
In-Reply-To: <AANLkTilCvgvf9Ch55f878nTNTue8tHYmcrLEywsjnylY@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201006100900.23981.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne Čt 10. června 2010 08:10:22 Eric Miao napsal(a):
> On Thu, May 20, 2010 at 1:05 PM, Eric Miao <eric.y.miao@gmail.com> wrote:
> > On Wed, May 19, 2010 at 11:46 PM, Cyril Hrubis <metan@ucw.cz> wrote:
> >> Hi!
> >> After some testing I found out that no usb gadget (g_ether,
> >> g_mass_storage, ...) is working after zaurus boots with kexec. So it
> >> seems like some missing initalization (it's working after doing reboot
> >> again) anybody has any clue, patch or ideas how to debug this?
> > 
> > Dumping out the registers of the two situations and doing a comparison
> > then might be a quick way.
> 
> Any debugging update on this?

Yeah, there's a workaround. Cyril's working on a proper fix, but that might take 
some time. Simply -- UP2OCR is misconfigured.
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
