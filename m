Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072Ab2JYXLp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 19:11:45 -0400
Received: from exprod7og103.obsmtp.com ([64.18.2.159]:59350 "EHLO
	exprod7og103.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894Ab2JYXLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 19:11:44 -0400
Message-ID: <5089C70B.1020007@genband.com>
Date: Thu, 25 Oct 2012 17:11:07 -0600
From: Chris Friesen <chris.friesen@genband.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Wallak <wallak@free.fr>
CC: linux-kernel@vger.kernel.org
Subject: Re: Linix-3.6.3 sda, sdb drives in reverse order (with a USB 2.0
 drives and a monolithic kernel configuration)
References: <5089C20E.4090707@free.fr>
In-Reply-To: <5089C20E.4090707@free.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Oct 2012 23:11:08.0198 (UTC) FILETIME=[04014460:01CDB306]
X-TM-AS-Product-Ver: SMEX-8.0.0.4160-6.500.1024-19310.000
X-TM-AS-Result: No--7.736600-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/2012 04:49 PM, Wallak wrote:
> I've a very annoying behavior with the linux-3.6.x kernels release, and
> a monolithic configuration. The USB 2.0 drives are mapped first with
> /dev/sda, /dev/sdb... devices, and than the SATA AHCI drives come after.
> This is out of order with the BIOS configuration and breaks a program
> like lilo. This is also annoying when we use a static partition mapping.
>
> Linux-3.5 works fine. Where this bug come from ? Is this a patch to get
> the old, and classical behavior ?

As you have discovered it's fragile to rely on /dev/sd* names since a 
BIOS update, kernel update, or motherboard replacement could conceivably 
cause them to change.

Better to use something like partition labels that you control and that 
don't change.

Chris
