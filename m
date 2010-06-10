Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758379Ab0FJSaL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 14:30:11 -0400
Received: from zcars04e.nortel.com ([47.129.242.56]:44554 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902Ab0FJSaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 14:30:09 -0400
Message-ID: <4C112E7B.1040101@nortel.com>
Date: Thu, 10 Jun 2010 12:27:07 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Brian Gordon <legerde@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Aerospace and linux
References: <AANLkTimrZvKyh6zYnUg2xzDVBVr5NxqtJhxZ42AVhkVI@mail.gmail.com>
In-Reply-To: <AANLkTimrZvKyh6zYnUg2xzDVBVr5NxqtJhxZ42AVhkVI@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Jun 2010 18:30:01.0648 (UTC) FILETIME=[F032FB00:01CB08CA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2010 11:29 AM, Brian Gordon wrote:

>     When these SEU can be detected some action may be taken to improve
> the behaviour of the system  (log a fault and reset in order to
> refresh things from scratch?).   So the first question becomes how to
> detect an SEU.

I do work in telco stuff.  We use ECC RAM, turn on ECC/parity on the
various buses, enable error-checking in the hardware, etc.

At higher abstraction levels you can checksum the data being stored and
validate it when you access it.

Some of the errors are "soft" and can be corrected, others are "hard"
and uncorrectable.  If you get enough "soft" errors in a short enough
time it may be desirable to treat it as a "hard" error and reset.

>   Thank you to anyone for any pointers on where I can look to learn
> more about detecting SEU in linux.

You might start by taking a look at the "edac" code in the kernel.
Linux in general doesn't normally enable all the fault detection code,
so you may need to start looking at datasheets.

Chris

-- 
The author works for GENBAND Corporation (GENBAND) who is solely
responsible for this email and its contents. All enquiries regarding
this email should be addressed to GENBAND. Nortel has provided the use
of the nortel.com domain to GENBAND in connection with this email solely
for the purpose of connectivity and Nortel Networks Inc. has no
liability for the email or its contents. GENBAND's web site is
http://www.genband.com
