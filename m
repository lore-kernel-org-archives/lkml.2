Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756992Ab1CBSQD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 13:16:03 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40021 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755568Ab1CBSQB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 13:16:01 -0500
Message-ID: <4D6E8932.1010405@zytor.com>
Date: Wed, 02 Mar 2011 10:15:14 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: RFC: x86: kill binutils 2.16.x?
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

binutils 2.16 (and presumably its prereleases, binutils 2.15.9x) appears
to have more bugs than any other version of binutils released in modern
history, *before or after*.

We chronically run into problems because that particular binutils
version breaks code that works fine elsewhere.

I would like to know who would suffer from formally discontinuing
support for that version.  I understand some version of SLES shipped it,
but I don't know for sure.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

