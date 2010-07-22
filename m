Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759910Ab0GVS21 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 14:28:27 -0400
Received: from outmail148094.authsmtp.co.uk ([62.13.148.94]:61770 "EHLO
	outmail148094.authsmtp.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759600Ab0GVS2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 14:28:14 -0400
X-Greylist: delayed 958 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Jul 2010 14:28:13 EDT
From: Ben Pfaff <blp@cs.stanford.edu>
To: Mattia Jona-Lasinio <mattia.jona@gmail.com>
Subject: Re: Introducing the LCD-Linux project
References: <AANLkTil5Gz4i6iGZcaAcU0hg_ynNP1UR7bLwv_VQU6Wm@mail.gmail.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk
Reply-To: Ben Pfaff <blp@cs.stanford.edu>
Date: Thu, 22 Jul 2010 11:12:02 -0700
In-Reply-To: <AANLkTil5Gz4i6iGZcaAcU0hg_ynNP1UR7bLwv_VQU6Wm@mail.gmail.com>
	(Mattia Jona-Lasinio's message of "Thu, 22 Jul 2010 13:00:34 +0200")
Message-ID: <87aapjbd3h.fsf@benpfaff.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Server-Quench: a253c512-95bc-11df-80b9-0022640b883e
X-AuthReport-Spam: If SPAM / abuse - report it at: http://www.authsmtp.com/abuse
X-AuthRoute: OCdwYQ8QAVZfSBwy AC4CFCFJRwtjIQdD FxoeKRdbOF4EFV8Q JBwAaXhONBpGHQgB E2cCUVVWWl10F2Jy aBRQawFDY09NQQRj T0pMQFdNFUs3B2F4 dR1tDxlwfgBEfTB4 ZE5mECFZWUcpcEd/ X0dRRz4bZGY0Pn0X UBJRagNUcgFMeh8X Ylh8AT1vNG8XHyQk BQg/IjswOzoXNCRY CiUmARc2QEAWDnYk XRcAED4zdQAO
X-Authentic-SMTP: 61633331373532.1015:706/Kp
X-AuthFastPath: 0 (Was 255)
X-AuthVirus-Status: No virus detected - but ensure you scan with your own anti-virus system.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mattia Jona-Lasinio <mattia.jona@gmail.com> writes:
> Ben Pfaff <blp@cs.stanford.edu> writes:
>> When I wanted to solve the same problem for a small
>> serial-connected LCD panel (sold under the name EZIO), I wrote a
>> program called "ezio-term" that has the same functionality but
>> runs entirely in userspace.  It connects to the serial port and
>> speaks the EZIO protocol on the serial port, and it creates a pty
>> and acts like an ANSI terminal on that pty.  Thus, it translates
>> back and forth between the two protocols.
>
> This is indeed a possibility. However, in my opinion, it always suffers
> the same problems: if you change the display, you have to rewrite everything
> from scratch since the protocol for a different display will be different.

It should not be necessary to rewrite everything, only to write
additional code to interface to the particular device.  This code
has to be written in any case, whether it is in userspace or the
kernel.

> I downloaded your program and I'm going through it.

I'm not pushing ezio-term as a general solution, by the way.  It
is clearly very specific to EZIO3 devices.  I'm just pointing out
that its approach is a reasonable alternative.
-- 
Ben Pfaff 
http://benpfaff.org
