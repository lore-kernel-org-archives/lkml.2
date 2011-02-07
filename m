Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089Ab1BGM42 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 07:56:28 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:51962 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937Ab1BGM41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 07:56:27 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Paul Bolle <pebolle@tiscali.nl>
Subject: Re: [PATCH] Export linux/syslog.h
Date: Mon, 7 Feb 2011 13:55:55 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Kees Cook <kees.cook@canonical.com>,
        David Woodhouse <dwmw2@infradead.org>
References: <1297079503.1741.10.camel@t41.thuisdomein>
In-Reply-To: <1297079503.1741.10.camel@t41.thuisdomein>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201102071355.55978.arnd@arndb.de>
X-Provags-ID: V02:K0:4zeMJqsHZ05z+kbvQ4Ta5/+F8pBNwG13MxoVIfecDce
 czogYAW3dBkyodmHxebrRNWjCKbDHN0V0r+QU1jYsBOOOtRxVJ
 HCB3DQHqENMBEZ/TUroHIbccnZN4TAsAeUyMMWDWvoDCicupaO
 9jUH0/tlAiTM85EBVqHrM0NrKDMrBmU7Xhuo9MCPTA9AMTsrTl
 nO2y9lguTYQakpozFCNtQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 February 2011, Paul Bolle wrote:
> Userspace programs (like util-linux' dmesg) still use magic numbers for
> the klogctl function (glibc's interface to the syslog system call).
> Exporting linux/syslog.h makes the more descriptive named constants
> available as a single reference for these values.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> Signed-off-by: Kees Cook <kees.cook@canonical.com>

It sounds reasonable to make this a proper ABI in general.

The comment in the header file currently starts with "Syslog internals".
If you want to export it, you should probably change that, too.
Further, the man page currently documents the raw numbers and should
be changed as well with the new constants.

	Arnd
