Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194Ab1BWIlW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 03:41:22 -0500
Received: from h1047321.serverkompetenz.net ([85.214.67.163]:35878 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754806Ab1BWIlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 03:41:21 -0500
Message-ID: <4D64C81B.5060807@ahsoftware.de>
Date: Wed, 23 Feb 2011 09:40:59 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alan Stern <stern@rowland.harvard.edu>,
        balbi@ti.com
Subject: Re: [024/115] USB: prevent buggy hubs from crashing the USB stack
References: <20110216014656.696621915@clark.kroah.org> <4D64BFF9.5050704@ahsoftware.de>
In-Reply-To: <4D64BFF9.5050704@ahsoftware.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 23.02.2011 09:06, schrieb Alexander Holler:
> Am 16.02.2011 02:44, schrieb Greg KH:
>> 2.6.32-longterm review patch. If anyone has any objections, please let
>> us know.
>
> This patch killed the MUSB-host-functionality here (on a BeagleBoard).

Sorry, haven't seen at first, that the question was for 2.6.32. I had to 
revert this patch for 2.6.37.1. Without the revert I've got endless 
messages that the "parent hub has no TT".

I've configured musb in gadget-mode and I'm loading g_zero to use a 
bt-dongle attached to the OTG-(MUSB-)port.

> Regards,
>
> Alexander
