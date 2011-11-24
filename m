Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809Ab1KXQFd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 11:05:33 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:64460 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130Ab1KXQFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 11:05:31 -0500
Message-ID: <4ECE6B47.90202@evidence.eu.com>
Date: Thu, 24 Nov 2011 17:05:27 +0100
From: Claudio Scordino <claudio@evidence.eu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.23) Gecko/20110922 Lightning/1.0b2 Thunderbird/3.1.15
MIME-Version: 1.0
To: Wolfram Sang <w.sang@pengutronix.de>
CC: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>, Juergen Beisert <jbe@pengutronix.de>,
        Matthias Fuchs <mfuchs@ma-fu.de>
Subject: Re: [PATCH 0/8] serial: 8250: support hw-based RS485 direction control
 (finally!)
References: <1321460685-15753-1-git-send-email-w.sang@pengutronix.de> <20111123150312.GH4063@pengutronix.de>
In-Reply-To: <20111123150312.GH4063@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 23/11/2011 16:03, Wolfram Sang ha scritto:
> On Wed, Nov 16, 2011 at 05:24:37PM +0100, Wolfram Sang wrote:
>> Some 8250-variants control the direction pin for RS485 in hardware. Linux has
>> RS485 support these days, so update the 8250-driver to adhere to that. There
>> have been attempts for mainlining this before. So, I started with the version
>> from Matthias which got no further comments, a proof-of-concept for the 16V2750
>> from Jürgen, and reworked it to match the current state of RS485 in Linux. Some
>> minor cleanup patches came along the way. Really looking forward to
>> comments/tags, because I think it is really time to get this functionality into
>> mainline once and for all ;)
> 
> Ping. Claudio? What do you think? 

Hi Wolfram,

	sorry for the delay, but I'm very busy these days.

I noticed that some of your patches revert the changes made by the previous patches in the 
same series. So I would have preferred having only one patch with the whole changes wrt to 
the mainline. 

However, I've understood that some of those patches come from a previous submission that you
preferred to not touch. And I can apply the whole series to check what are the actual changes,
so its' fine.

The RS485 part looks right. 

I had a superficial look also at the rest of the code, and its seems OK too.  But, honestly, I couldn't 
find the time to read it carefully.

Best regards,

	Claudio
