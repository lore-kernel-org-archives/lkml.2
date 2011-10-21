Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752152Ab1JUT7j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 15:59:39 -0400
Received: from server655-han.de-nserver.de ([85.158.177.45]:46274 "EHLO
	server655-han.de-nserver.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751985Ab1JUT7i convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 15:59:38 -0400
References: <4EA1536E.6090001@profihost.ag> <20111021130752.GC8219@suse.de>
In-Reply-To: <20111021130752.GC8219@suse.de>
Mime-Version: 1.0 (iPhone Mail 8H7)
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <AA4CF3E1-3D52-418E-BED9-F34BD22168C3@profihost.ag>
Cc: LKML <linux-kernel@vger.kernel.org>, Stable Tree <stable@kernel.org>
X-Mailer: iPhone Mail (8H7)
From: Stefan Priebe <s.priebe@profihost.ag>
Subject: Re: Kernel hard LOCKUP with v3.0.7
Date: Fri, 21 Oct 2011 21:59:30 +0200
To: Greg KH <gregkh@suse.de>
X-User-Auth: Auth by s.priebe@profihost.ag through 79.194.221.44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, Oct 21, 2011 at 01:11:42PM +0200, Stefan Priebe - Profihost AG wrote:
>> Hello list,
>> 
>> today i've seen the following crash using v3.0.7 (renamed to 2.6.40.7).
>> 
>> http://pastebin.com/raw.php?i=sRq7T4Y0
>> 
>> I haven't seen this with 3.0.6 but i also changed some kernel config
>> options (activated ipv6, changed from SLAB to SLUB).
> 
> Any way to reproduce it?
> 
> greg k-h
No idea the systrm is just crashing every 2-6 hours. I've now also tried to use slab. No difference. So i will revert to 3.0.6 which is running fine.

Stefan