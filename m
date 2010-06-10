Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759572Ab0FJSth (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 14:49:37 -0400
Received: from zrtps0kp.nortel.com ([47.140.192.56]:39162 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759508Ab0FJStf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 14:49:35 -0400
Message-ID: <4C11330A.4040309@nortel.com>
Date: Thu, 10 Jun 2010 12:46:34 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Brian Gordon <legerde@gmail.com>
CC: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: Aerospace and linux
References: <AANLkTimrZvKyh6zYnUg2xzDVBVr5NxqtJhxZ42AVhkVI@mail.gmail.com>	<877hm64ui4.fsf@basil.nowhere.org> <AANLkTik3XiOjYM67RdPG-3RM3rY-0vondiMmJsETAHfX@mail.gmail.com>
In-Reply-To: <AANLkTik3XiOjYM67RdPG-3RM3rY-0vondiMmJsETAHfX@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Jun 2010 18:49:28.0173 (UTC) FILETIME=[A78091D0:01CB08CD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2010 12:38 PM, Brian Gordon wrote:

> On the more exotic end, I have also seen systems that have dual
> redundant processors / memories.  Then they add compare logic between
> the redundant processors that compare most pins each clock cycle.   If
> any pins are not identical at a clock cycle, then something has gone
> wrong (SEU, hardware failure, etc..)

Some phone switches do this.  Some of them also have at least two copies
of everything in memory and will do transactional operations that can be
rolled back if there is a hardware glitch.

> So, some pages of RAM are going to be read-only and the data in those
> pages came from some source (file system?).   Can anyone describe a
> high level strategy to occasionaly provide some coverage of this data?

> So far I have thought about page descriptors adding an MD5 hash
> whenever they are read-only and first being "loaded/mapped?" and then
> a background daemon could occasionaly verify.

Makes sense to me.  You might also pick an on-disk format with extra
checksumming so you could compare the on-disk checksum with the
in-memory checksum.

Chris

-- 
The author works for GENBAND Corporation (GENBAND) who is solely
responsible for this email and its contents. All enquiries regarding
this email should be addressed to GENBAND. Nortel has provided the use
of the nortel.com domain to GENBAND in connection with this email solely
for the purpose of connectivity and Nortel Networks Inc. has no
liability for the email or its contents. GENBAND's web site is
http://www.genband.com
