Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759557Ab0FJTPA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 15:15:00 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:59036 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472Ab0FJTO6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 15:14:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ct6d9/G5bV1GDQjRLtc4TfbVFeze1eW2tOYC/+UsdxoSIYyqcYctV5qleadcT1ZHS9
         8GDVQvdyKhYuBQUQ9OnNgIZklWHh3NxbwF8coidcXJgZuEIsl1dEMXlSke0+CeBh/Rc0
         2aiuaTwztYeQZH6w4LIPVLHiE4/gS20Yk5rM0=
MIME-Version: 1.0
In-Reply-To: <4C11330A.4040309@nortel.com>
References: <AANLkTimrZvKyh6zYnUg2xzDVBVr5NxqtJhxZ42AVhkVI@mail.gmail.com>
	<877hm64ui4.fsf@basil.nowhere.org>
	<AANLkTik3XiOjYM67RdPG-3RM3rY-0vondiMmJsETAHfX@mail.gmail.com>
	<4C11330A.4040309@nortel.com>
Date: Thu, 10 Jun 2010 13:14:57 -0600
Message-ID: <AANLkTimcJx1XMW3XHJD44EJpOnmMzM6KdMDZAs0Adjgr@mail.gmail.com>
Subject: Re: Aerospace and linux
From: Brian Gordon <legerde@gmail.com>
To: Chris Friesen <cfriesen@nortel.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you both.    This has been very helpful for me.

I think I read two conclusions:
1) R/O is a small percentage of RAM
2) To cover this small precentage would be non-trivial

Thank you both very much for your time and knowledge, I'll move along now.



On Thu, Jun 10, 2010 at 12:46 PM, Chris Friesen <cfriesen@nortel.com> wrote:
> On 06/10/2010 12:38 PM, Brian Gordon wrote:
>
>> On the more exotic end, I have also seen systems that have dual
>> redundant processors / memories.  Then they add compare logic between
>> the redundant processors that compare most pins each clock cycle.   If
>> any pins are not identical at a clock cycle, then something has gone
>> wrong (SEU, hardware failure, etc..)
>
> Some phone switches do this.  Some of them also have at least two copies
> of everything in memory and will do transactional operations that can be
> rolled back if there is a hardware glitch.
>
>> So, some pages of RAM are going to be read-only and the data in those
>> pages came from some source (file system?).   Can anyone describe a
>> high level strategy to occasionaly provide some coverage of this data?
>
>> So far I have thought about page descriptors adding an MD5 hash
>> whenever they are read-only and first being "loaded/mapped?" and then
>> a background daemon could occasionaly verify.
>
> Makes sense to me.  You might also pick an on-disk format with extra
> checksumming so you could compare the on-disk checksum with the
> in-memory checksum.
>
> Chris
>
> --
> The author works for GENBAND Corporation (GENBAND) who is solely
> responsible for this email and its contents. All enquiries regarding
> this email should be addressed to GENBAND. Nortel has provided the use
> of the nortel.com domain to GENBAND in connection with this email solely
> for the purpose of connectivity and Nortel Networks Inc. has no
> liability for the email or its contents. GENBAND's web site is
> http://www.genband.com
>
