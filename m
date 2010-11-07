Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055Ab0KGUvk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 15:51:40 -0500
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:56531 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752603Ab0KGUvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 15:51:38 -0500
Message-ID: <4CD71131.3080706@euromail.se>
Date: Sun, 07 Nov 2010 21:50:57 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Rafi Rubin <rafi@seas.upenn.edu>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chris Bagwell <chris@cnpbagwell.com>,
        Chase Douglas <chasedouglas@gmail.com>, Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH] input: Introduce light-weight contact tracking
References: <1289161108-32309-1-git-send-email-rydberg@euromail.se> <4CD70FC0.6060503@seas.upenn.edu>
In-Reply-To: <4CD70FC0.6060503@seas.upenn.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1PFCCl-0007dG-Bl.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1PFCCl-0007dG-Bl 23cd47d5ee4b4237f5e4086742f54e56
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2010 09:44 PM, Rafi Rubin wrote:

> On 11/07/2010 03:18 PM, Henrik Rydberg wrote:
>> Some kernel drivers demand the use of contact tracking for proper
>> filtering and pointer emulation. With one exception, these drivers
>> are limited to a maximum of four concurrent contacts. This patch adds
>> a simple matcher for up to four contacts, with these notable properties:
> 
> Tracking in the ntrig driver needs to support a minimum of 6 fingers.  I have
> also seen press releases claiming 10+ eventually.  I don't know if those devices
> will support tracking in the hardware/firmware.


This is the exception I was talking about. The thing is, I can very well see a
driver supporting four fingers even if the device claims to support six. After
all, getting those four fingers working well will still be a big improvement.

Henrik
