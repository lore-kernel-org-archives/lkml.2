Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791Ab0I3RfE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 13:35:04 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45302 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755879Ab0I3RfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 13:35:02 -0400
From: Andi Kleen <andi@firstfloor.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jean Delvare <khali@linux-fr.org>, Olof Johansson <olof@lixom.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] dmi: export dmi data through debugfs
References: <20100928211246.GA20941@lixom.net>
	<20100929093403.7db92388@endymion.delvare>
	<20100929145330.GA9351@lixom.net>
	<20100929171118.1dbf3fbb@endymion.delvare>
	<20100929222804.7f506ba5@lxorguk.ukuu.org.uk>
Date: Thu, 30 Sep 2010 19:34:57 +0200
In-Reply-To: <20100929222804.7f506ba5@lxorguk.ukuu.org.uk> (Alan Cox's message
	of "Wed, 29 Sep 2010 22:28:04 +0100")
Message-ID: <87pqvvuoce.fsf@basil.nowhere.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> writes:

>> Now if you really insist on exposing the whole DMI table through sysfs,
>> I can't prevent you from doing that. After all, ACPI already exposes
>> its tables under /sys/firmware/acpi/tables (mode 0400). But then you'd
>> rather expose the DMI entry point and tables
>> under /sys/firmware/dmi/tables for consistency, rather than using
>> debugfs. But again, I don't think it is adding any value over what we
>> already have.
>
> If you really the DMI data generally available run dmidecode in the boot
> scripts directed to a file. It even has a dump mode for this.

FWIW i have been pondering to put DMI into sysfs too. One of the reasons
mcelog has to start up as root is that it needs to get these tables
out of /dev/mem.

Just having a binary file to read would be fine though, no need to 
do decoding.

-andi

-- 
ak@linux.intel.com -- Speaking for myself only.
