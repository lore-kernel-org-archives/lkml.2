Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932901Ab1AMJ0J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 04:26:09 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39903 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932610Ab1AMJ0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 04:26:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=A61S3gHHay+V2mqPDs8HsJNsKfxJVPjizdFIkeFc5RmTR8fofYBoAHW87+G5MkI0dG
         9Ma6l02NuawWtQ+Zej5+2F/lE+W1x7zNCBI5kak8a5Hvzp3XVshRmcrYrM2fw2fWlypF
         DsqGrlLvJZn+2hpZl8yCl4DrlvoDP9573cD58=
Message-ID: <4D2EC528.1020704@gmail.com>
Date: Thu, 13 Jan 2011 10:26:00 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: deepak.kodihalli@nokia.com
CC: linux-kernel@vger.kernel.org
Subject: Re: Question about tty layer
References: <CFCD2552B303EB4C99229AB4A7875CF901429DE1@008-AM1MPN1-021.mgdnok.nokia.com>
In-Reply-To: <CFCD2552B303EB4C99229AB4A7875CF901429DE1@008-AM1MPN1-021.mgdnok.nokia.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2011 07:16 AM, deepak.kodihalli@nokia.com wrote:
> Does the tty layer buffer requests from the host if the tty has not been opened?
> 
> Supposing I'm working with an interface on /dev/ttyGS1. If the user space has not opened this yet, but USB is connected, would this allow the host to send data packets to this interface? If yes, and if user space opens ttyGS1 at a later stage and say adds a GIO watch on it for POLLIN, would user space receive that pollin?

It depends on the driver and the device. Most of devices are off until
open is called in their driver. So no buffers are filling neither in
device, nor in the kernel.

regards,
-- 
js
