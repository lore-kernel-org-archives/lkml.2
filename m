Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886Ab1BWIQ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 03:16:58 -0500
Received: from h1047321.serverkompetenz.net ([85.214.67.163]:41170 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754619Ab1BWIQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 03:16:57 -0500
Message-ID: <4D64BFF9.5050704@ahsoftware.de>
Date: Wed, 23 Feb 2011 09:06:17 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [024/115] USB: prevent buggy hubs from crashing the USB stack
References: <20110216014656.696621915@clark.kroah.org>
In-Reply-To: <20110216014656.696621915@clark.kroah.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 16.02.2011 02:44, schrieb Greg KH:
> 2.6.32-longterm review patch.  If anyone has any objections, please let us know.

This patch killed the MUSB-host-functionality here (on a BeagleBoard).

Regards,

Alexander


