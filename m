Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564Ab0LEHrV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 02:47:21 -0500
Received: from mx1.brouhaha.com ([64.62.206.9]:47406 "EHLO mx1.brouhaha.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753849Ab0LEHrT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 02:47:19 -0500
Message-ID: <4CFB4386.3010806@brouhaha.com>
Date: Sat, 04 Dec 2010 23:47:18 -0800
From: Eric Smith <eric@brouhaha.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Thunderbird/3.1.6
MIME-Version: 1.0
To: Kyle Moffett <kyle@moffetthome.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: mmap to address zero with MAP_FIXED returns ENOPERM for non-root
 users?
References: <4CFB33DA.1070306@brouhaha.com> <AANLkTikPESSNMRQ+WbzpLoRyhhK1UQRvnB5ifpUp+cnk@mail.gmail.com>
In-Reply-To: <AANLkTikPESSNMRQ+WbzpLoRyhhK1UQRvnB5ifpUp+cnk@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle Moffett wrote:
 > This is a specific security feature designed to reduce the security
 > impact of a kernel NULL-pointer dereference.

Thanks for the explanation!

 > Since you're performing binary translation of a microcontroller, it
 > may be better to perform some kind of minimal memory-map translation
 > as a part of that.

That's exactly what I'd hoped to avoid, as it does result in a 
non-trivial performance hit.  I suppose I can make it a configuration 
option of my translator.

I'm curious, though.  How likely are exploits where I can trick the 
kernel into calling a function at 0 in my virtual address space, but not 
trick it into calling a function at some non-zero address of my choosing?

Best regards,
Eric

