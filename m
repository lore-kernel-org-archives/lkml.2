Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751749Ab0CSLpq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 07:45:46 -0400
Received: from mail-qy0-f182.google.com ([209.85.221.182]:40399 "EHLO
	mail-qy0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168Ab0CSLpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 07:45:44 -0400
X-Greylist: delayed 433 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Mar 2010 07:45:44 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=PSbEEkYOfRRo+2emY6A+WMl18eQhFMQ1TMqCptSCo8Zmk/etlgtQXDLG4Bl8suJ690
         DUlDACx5zg5OVbR8uhsAEYPeTe3k8cn3CIK0jBigypsozNdRrqbqukuwm+zSyhSWqn7M
         yYdWFh4FVleScNZEh04u4eDK1qFR+NMJYbSc4=
MIME-Version: 1.0
In-Reply-To: <4BA358DB.20708@enmesh.se>
References: <4BA358DB.20708@enmesh.se>
Date: Fri, 19 Mar 2010 17:08:28 +0530
Message-ID: <5d5443651003190438s17330100vc1d91c9089f7e7f2@mail.gmail.com>
Subject: Re: input: mt: Software finger tracking in the kernel?
From: Trilok Soni <soni.trilok@gmail.com>
To: Henrik Rydberg <rydberg@enmesh.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input <linux-input@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik,

On Fri, Mar 19, 2010 at 4:28 PM, Henrik Rydberg <rydberg@enmesh.se> wrote:
> Hi Dmitry,
>
> there is an ongoing discussion about adding multitouch to X
> (http://lists.x.org/archives/xorg-devel/2010-March/006206.html), which is
> beginning to take on more solid form.
>
> One of the suggestions emerging from that discussion is to add the software
> finger tracking to the kernel. Back in summer 2009 when I thought about this, I
> disregarded it as being too experimental. I have since then reconsidered,
> starting to think it really is the right place.
>
> The MT protocol allows applications to take advantage of multi-contact hardware,
> but leaves the problems of finger tracking and filtering to the user. Arguably,
> no application can make good use of MT without these, so the problem is pushed
> forward, in this case to evdev or equivalent.
>
> The knowledge of signal-to-noise ratios and prior input states resides in the
> kernel. Because of this, the finger matching and filtering would naturally
> reside within the kernel.
>
> So, if there were to appear patches to include matching in the input core, would
> you consider them? :-)

Please post your patches for the further discussion. Last time I
referred the Android userspace code it was also not using TRACKING_ID
as defined in MT protocol even if the kernel driver emits them.


-- 
---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni
