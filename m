Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758572Ab1EZV0m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 17:26:42 -0400
Received: from DMZ-MAILSEC-SCANNER-8.MIT.EDU ([18.7.68.37]:45475 "EHLO
	dmz-mailsec-scanner-8.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758543Ab1EZV0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 17:26:41 -0400
X-AuditID: 12074425-b7b78ae000007e02-38-4ddec581b451
Message-ID: <4DDEC589.3010201@mit.edu>
Date: Thu, 26 May 2011 17:26:33 -0400
From: Andy Lutomirski <luto@MIT.EDU>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT pull] x86 vdso updates
References: <alpine.LFD.2.02.1105262049180.3078@ionos>
In-Reply-To: <alpine.LFD.2.02.1105262049180.3078@ionos>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Se0hTYRjG+XbOtrOxE59Hl5+zjE6adpkVRY0u0p2BrKToH+l23I47o904
	Z15mCAoVKmL+U64xykERmKEuRTMSNgotUmQWhJFUFomhktdwlJ2jePnv4f097/PwfbwERvnk
	OsLm9LC8k7HTCjVOqbQ79OWvh0y7RxfUhkBTo8Iw0BlQGJ6F7mCGbzVjSsOf5mH5Ubkx1FCp
	MI739SmNPb4YbpwKpeTguerDFtZuK2T5XVlX1Zzvd677JygeqZ0AZaANVAEVgeA+VB3sw5f0
	etQ/1KSoAmqCgl0A3W6PYRKgYDNArbcuLIF+GQp21ikkQMKtqGvk3aIJh2mounxYLmkFTEUV
	j77IJK2FXjTe2Kpc8sehN/e+L7YlwAzUEh3EpFAMPgSo5dO0uEwQ8SIYGS6SJAX3o/DNDMmu
	ggfQfPQDLo0xeAjNvuClMQY3ofaxAFYL4vxrCvyrLv8aVz3AGsBGi6NE72BsdoE16wUz43Sy
	vN6Q6bB5MllLQQhIn648mdYBaiN0BEAC0BryVP6QiZIzhYLXEQFJhIzWkq6wOFqX57J4OUbg
	rvAFdlaIAERgdAJJVIqMtDDeEpZ3LaNkAqcTyQdJ6SYKWhkPe41l3Sy/TDcQBI3I+VfiYhzP
	WtnifJvds4plhEoK14jhk5KHFNyMQ7BZl/hboCe6OzrCgMKdLierSySheDEUlExcgXMlZ/mg
	RkGi+Kx4ckaK0ojntpI0KpbIxJKdsc9SiYdZRboy4D3XlmzqncCyZ5RdMc2xyyVTvi3q1rZm
	7ky/mdt8I5zx/Pzsk2bzD0V+Q/CExfqxKt1qqr87Vz8w96soWnocc9eV5h4Z4+4HyOjptu5p
	+uC2QcZ33Z+yUBNsyQGdEbZHqX3ZdLH3PXb2Xyj7L9f+mGt9apHnfU3dO6nLqrhE4wLH7NmO
	8QLzH9nNP18rAwAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26/2011 02:50 PM, Thomas Gleixner wrote:
>        x86-64: Add time to vDSO

And here's the glibc bug:

http://sourceware.org/bugzilla/show_bug.cgi?id=12813

Let the deprecation of the vsyscall page begin :)

--Andy
