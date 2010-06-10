Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759572Ab0FJTeI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 15:34:08 -0400
Received: from smtp-out29.alice.it ([85.33.2.29]:4111 "EHLO
	smtp-out29.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472Ab0FJTeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 15:34:06 -0400
X-Greylist: delayed 615 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Jun 2010 15:34:06 EDT
Message-ID: <4C113BC2.6070000@libero.it>
Date: Thu, 10 Jun 2010 21:23:46 +0200
From: Massimiliano Galanti <massiblue@libero.it>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100411 Icedove/3.0.4
MIME-Version: 1.0
To: Brian Gordon <legerde@gmail.com>, Chris Friesen <cfriesen@nortel.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Aerospace and linux
References: <AANLkTimrZvKyh6zYnUg2xzDVBVr5NxqtJhxZ42AVhkVI@mail.gmail.com>	<4C112E7B.1040101@nortel.com> <AANLkTinIAKHVYKiILxQZXTr30K_Cr5EZQwRzNpYlLULw@mail.gmail.com>
In-Reply-To: <AANLkTinIAKHVYKiILxQZXTr30K_Cr5EZQwRzNpYlLULw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Jun 2010 19:23:46.0235 (UTC) FILETIME=[7233E8B0:01CB08D2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> What about .ro and .text sections of an executable?   I would think
> kernel support for that would be required.   If its application data,
> then all sorts of things are possible like you described.   Ive also
> seen critical ram variables be stored in triplicate and then
> compared/voted just to ensure no silent SEU corruption.

Maybe slightly off topic but... if flash is safer than ram, what about 
using XIP (where possible, e.g. on NORs)? That would not put .data 
sections into ram, at least.

-- 
Massimiliano
