Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754336Ab0CYAv3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 20:51:29 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:55651 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754242Ab0CYAv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 20:51:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=q26zVN2w1u32YWLnRXcrgxaXBVTPC+d1/6h9RwWP5th5qQ6vkr6YMC63BJYfGBq9f1
         jftuPR7UKjgV/Z0tl/IywVJW/QHdoIhVtHb4H+NgQrtBOhueSFKJr/JTcw+4h6GLZ+ou
         1CIutmec4AB3+xLAI19SK69S/EZynjYRyoas4=
Message-ID: <4BAAB38C.3070202@gmail.com>
Date: Wed, 24 Mar 2010 18:51:24 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: turbolad995@yahoo.co.uk
CC: linux-kernel@vger.kernel.org
Subject: Re: Major Linux sound bugs
References: <4BAA6405.968.842BC@turbolad995.yahoo.co.uk>
In-Reply-To: <4BAA6405.968.842BC@turbolad995.yahoo.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24/2010 01:12 PM, turbolad995@yahoo.co.uk wrote:
> Hi. I don't know who to contact about this, but nobody seems to know
> how to fix this problem or where/why it's occurring.  Here's the
> lowdown: in Linux distributions such as Ubuntu, some programs will
> only work with sound when you close ALL other programs first. I've
> mentioned this on Launchpad, but nobody seems to know why or how to
> fix it.
>
> Thank you for reading.

This isn't a kernel issue. Usually this is due to those programs 
incorrectly accessing device-specific ALSA devices like "hw:0", etc. 
rather than just using the "default" PCM device. Doing this bypasses 
software mixing and requires exclusive access to the sound device.
