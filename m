Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753165Ab2GWNdc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 09:33:32 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:50404 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752539Ab2GWNda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 09:33:30 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgQFAIZRDVBbdWOb/2dsb2JhbABFhSu0C4EHgiABAQUyAQUdIwEQCw4KCRYPCQMCAQIBRQYNAQcBAReHdr1ai02GUwOVSYVbijKCYQ
X-IronPort-AV: E=Sophos;i="4.77,639,1336341600"; 
   d="scan'208";a="948408350"
Message-ID: <500D52A7.8040606@igalia.com>
Date: Mon, 23 Jul 2012 15:33:27 +0200
From: =?ISO-8859-1?Q?Miguel_G=F3mez?= <magomez@igalia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Matthew Garrett <mjg@redhat.com>
CC: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>, don@syst.com.br,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1 v2] classmate-laptop: Add support for Classmate V4
 accelerometer.
References: <cover.1340976795.git.magomez@igalia.com> <39ac42c709e498fbef4f0f0f24edc5331e5f4473.1340976795.git.magomez@igalia.com> <20120717224749.GA20813@nautilus.holoscopio.com> <5006BFEC.1010407@igalia.com> <20120723132841.GD21495@srcf.ucam.org>
In-Reply-To: <20120723132841.GD21495@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El 23/07/12 15:28, Matthew Garrett escribió:
> On Wed, Jul 18, 2012 at 03:53:48PM +0200, Miguel Gómez wrote:
>
>>> 1) reverting the patch in acpica that puts all names in uppercase
>>> 2) using a case-insensitive match in acpi bus driver
>>> 3) using uppercase name in classmate-laptop driver
>>
>> I think the easiest and less risky way to fix this is by adding a
>> new hardware id (as proposed in the thread's patch), as it doesn't
>> add any side effects (that the other solutions might add), and it
>> doesn't break the behaviour of the old code.
>
> I've lost track of the implementation state here - if all names are
> upper-cased in acpica, why is this not already matching?

Names are upper-cased in acpica, so the device is reported as FNBT0000. 
But in the driver it's named FnBT0000, and that's why it doesn't match.

-- 
Miguel Gómez
Igalia - http://www.igalia.com
