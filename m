Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932736Ab2AEUJq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 15:09:46 -0500
Received: from us-mx3.synaptics.com ([12.239.217.85]:9618 "EHLO
	us-mx3.synaptics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932448Ab2AEUJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 15:09:45 -0500
X-PGP-Universal: processed;
	by securemail.synaptics.com on Thu, 05 Jan 2012 11:57:37 -0800
Message-ID: <4F060388.80802@synaptics.com>
Date: Thu, 5 Jan 2012 12:09:44 -0800
From: Christopher Heiny <cheiny@synaptics.com>
Organization: Synaptics, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc14 Thunderbird/3.1.11
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Jean Delvare <khali@linux-fr.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Subject: Re: [RFC PATCH 00/11] input: Synaptics RMI4 Touchscreen Driver
References: <1324519802-23894-1-git-send-email-cheiny@synaptics.com> <20120105075855.GD31895@core.coreip.homeip.net>
In-Reply-To: <20120105075855.GD31895@core.coreip.homeip.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/2012 11:58 PM, Dmitry Torokhov wrote:
> On Wed, Dec 21, 2011 at 06:09:51PM -0800, Christopher Heiny wrote:
>> This patch implements a driver supporting Synaptics ClearPad and other
>> touchscreen sensors that use the RMI4 protocol, as defined here:
>>
>>      http://www.synaptics.com/sites/default/files/511-000136-01-Rev-E-RMI4%20Intrfacing%20Guide.pdf
>>
>> as well as successor documents that haven't made their way through to
>> publication yet.

[snip]


>>      - character device access to the RMI4 register map via rmidev
>
> Could you please tell me why this facility is needed?

In conjunction with an Android application (Synaptics RED), this allows 
the PC-based Design Studio 4 configuration and diagnostic tool to access 
the RMI4 sensor via USB, Wifi, Bluetooth, etc.  We figured it might also 
be useful to the general development community, so we included it here.

					Chris
