Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183Ab1JPN1j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 09:27:39 -0400
Received: from oceanic.CalvaEDI.COM ([89.202.194.168]:62539 "EHLO
	oceanic.CalvaEDI.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423Ab1JPN1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 09:27:38 -0400
Message-ID: <4E9ADBD3.4070404@calvaedi.com>
Date: Sun, 16 Oct 2011 15:27:47 +0200
From: John Hughes <john@calvaedi.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.16) Gecko/20111004 Icedove/3.0.11
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Mattia Dongili <malattia@linux.it>,
        Stelian Pop <stelian@popies.net>
Subject: Re: sony-laptop driver: Volume keys on Sony Vaio TX3 don't work
References: <4E9ABBF6.3000504@calvaedi.com>
In-Reply-To: <4E9ABBF6.3000504@calvaedi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2011 01:11 PM, John Hughes wrote:
> Even though sony-laptop has code to handle the volume-up/volume-down 
> keys they don't work.  Pressing volume-down gets treated as 
> SONYPI_EVENT_PKEY_P1 and volume-up as SONYPI_EVENT_PKEY_P2.

And of course this bug has already been fixed.  Was looking at an old 
version, 2.6.32, sorry.

> Re-ordering the entries in the table type3_events and fixing the bug 
> in sonypi_volumeev (up and down were inverted) makes the volume keys 
> work.

But the current head version still has the bug where volume up/volume 
down are switched.

