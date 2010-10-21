Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758224Ab0JUVqk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 17:46:40 -0400
Received: from mtagate7.de.ibm.com ([195.212.17.167]:49659 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851Ab0JUVqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 17:46:38 -0400
Message-ID: <4CC0B4B5.8040006@de.ibm.com>
Date: Thu, 21 Oct 2010 23:46:29 +0200
From: Christian Borntraeger <borntraeger@de.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.12) Gecko/20100918 Lightning/1.0b1 Icedove/3.0.8
MIME-Version: 1.0
To: Mitchell Erblich <erblichs@earthlink.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: Verification of SYScall changes because of CVE-2009-0029
References: <7E55CE8C-959B-42B7-B991-4E385D1D6E38@earthlink.net>
In-Reply-To: <7E55CE8C-959B-42B7-B991-4E385D1D6E38@earthlink.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 21.10.2010 07:40, schrieb Mitchell Erblich:
> he ABI in the Linux kernel 2.6.28 and earlier on s390, powerpc, sparc64, and mips
> 64-bit platforms requires that a 32-bit argument in a 64-bit register was properly
> sign extended when sent from a user-mode application, but cannot verify this, which
> allows local users to cause a denial of service (crash) or possibly gain privileges 
> via a crafted system call.
> 
> Has anyone been able to verify  (a program that exploits this issue) ?

I found the problem with crashme and I was able to reduce the test to a
5 line C program - so yes, the problem can happen for real. The thing is
that this was no generic exploit, the problem from the testcase existed 
only with specific gcc, kernel, syscall and architecture but there might
be others - we dont know. So sorry, there is no generic test case that 
checks if the problem is fixed.

Christian


