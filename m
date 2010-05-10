Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461Ab0EJHtB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 03:49:01 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:53158 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751923Ab0EJHs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 03:48:59 -0400
X-Sasl-enc: CHW0s+v7fcEjB1irAtE1EjpfDogZBvysHFl88MnOtBcm 1273477738
Message-ID: <4BE7BA68.90600@ladisch.de>
Date: Mon, 10 May 2010 09:48:56 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Don Prince <dhprince.devel@yahoo.co.uk>
CC: linux-input@vger.kernel.org, alsa-devel@alsa-project.org,
       linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH 2.6.34-rc5 v2] HID: Prodikeys PC-MIDI HID
 Driver
References: <4BE6E4FA.10204@yahoo.co.uk>
In-Reply-To: <4BE6E4FA.10204@yahoo.co.uk>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don Prince wrote:
> A specialised HID driver for the Creative Prodikeys PC-MIDI USB Keyboard.
> 
> The Prodikeys PC-MIDI is a multifunction keyboard comprising a qwerty 
> 
> keyboard, multimedia keys and a touch sensitive musical keyboard.
> 
> The specialised HID driver adds full support for the musical keyboard 
> 
> and extra multimedia keys which are not currently handled by the default 
> 
> HID driver.
> 
> The specialised HID driver interfaces with Alsa, and presents the midi 
> 
> keyboard as a Rawmidi device. Sustain duration, octave shifting and the  
> 
> midi output channel can be read/written form userspace  via sysfs.

Thunderbird does this when it reads the text from another mail (neither
directly typed in nor pasted from the clipboard); the patch itself is
fine.

> Signed-off-by: Don Prince <dhprince-devel@yahoo.co.uk>

for the ALSA parts:
Acked-by: Clemens Ladisch <clemens@ladisch.de>


You should send the patch not only to the list but also to the HID
maintainer.


Regards,
Clemens
