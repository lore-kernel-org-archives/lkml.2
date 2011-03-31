Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758539Ab1CaQJO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 12:09:14 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58352 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437Ab1CaQJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 12:09:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=YTXJH7amLXqxAj20EfqTUE0joh9D9FKVBXCKYEx4AYTqh5+HnfVdRWfojbUdc9KdDi
         Ry+KoFpIdfzeXmEAy8gZxrYp3/wkTPZDFyj07Ryc8dEaejDC+k5W9OParE5pjFBVNcia
         LsLndMNJGu3t5ob6238ka2KZlr53SIvBWtlbY=
MIME-Version: 1.0
In-Reply-To: <4D946C73.4090402@ladisch.de>
References: <AANLkTin17=rCU4eDGYtnVFZ1ffbUn+var4Q_AQUuGKaw@mail.gmail.com>
	<4D946C73.4090402@ladisch.de>
Date: Thu, 31 Mar 2011 18:09:09 +0200
Message-ID: <AANLkTinyRqEa_ML47DOqAJU8aLDEA12geiUUrPGjXHrN@mail.gmail.com>
Subject: Re: Linux 2.6.38 freeze because of sound/core/pcm_lib.c commit 59ff878ffb26bc0be812ca8295799164f413ae88
From: "Christopher K." <c.krooss@googlemail.com>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31 March 2011 13:58, Clemens Ladisch <clemens@ladisch.de> wrote:
> Please try this patch:

I'm afraid the patch you provided did not change anything for me. I
applied it to 2.6.38.2,
still freezes 15 - 20 seconds after startup (Could be around the time
pulseaudio initializes).
Is there any way to provide you with more debug information?

Onboard: VIA VT1828S

HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
HDA Intel 0000:00:1b.0: irq 47 for MSI/MSI-X
HDA Intel 0000:00:1b.0: setting latency timer to 64
nvidia: module license 'NVIDIA' taints kernel.
hda-codec: no NID for mapping control Independent HP:0:0
HDA Intel 0000:01:00.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
hda_intel: Disable MSI for Nvidia chipset
HDA Intel 0000:01:00.1: setting latency timer to 64
...
hda_intel: Disable MSI for Nvidia chipset
nvidia 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
nvidia 0000:01:00.0: setting latency timer to 64
NVRM: loading NVIDIA UNIX x86_64 Kernel Module  270.30  Fri Feb 25
14:34:55 PST 2011

I use a Nvidia gtx 460, could it be related (as it features sound capabilities)?
Using nouveau does not change anything, neither does 2.6.39-rc1.
