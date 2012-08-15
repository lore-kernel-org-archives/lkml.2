Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764Ab2HOQOG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 12:14:06 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:60695 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088Ab2HOQOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 12:14:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v2 13/31] arm64: Device specific operations
Date: Wed, 15 Aug 2012 16:13:57 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com> <1344966752-16102-14-git-send-email-catalin.marinas@arm.com>
In-Reply-To: <1344966752-16102-14-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 7bit
Message-Id: <201208151613.57400.arnd@arndb.de>
X-Provags-ID: V02:K0:stHZIF8RDWa7AZH2NJHmPm8ju/+S48mGCQdPs7SY8r1
 J/Sdq+PTKfrfwruCyqQdGXJF7zWBlD9AHWYTCAzo8It015KQpf
 nBXzj2A+dN4QDwOqCwP54PbihUe0jhxzC8vDz6wdqAwBElmgiX
 MKQLyOonsU/yun0JNxYLKOEM+zo1A/2H8CfiCCAOLSInIgiCn6
 3+vWxwrSg7cE3RH5VB74UslWis48tOWH5tnNSDAgZRdE3c53iO
 6+68ya2JaflcJE/3gohDytl9a0jdxmoF2XDd/rDJiysQDRr/ay
 T5Ky0Fs4mczAznKsG1AYMz6FMsGomS2eCmJc9XGfsutTEDDXIH
 FViLN9hWsys8LOviDhYc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 August 2012, Catalin Marinas wrote:
> 
> This patch adds several definitions for device communication, including
> I/O accessors and ioremap(). The __raw_* accessors are implemented as
> inline asm to avoid compiler generation of post-indexed accesses (less
> efficient to emulate in a virtualised environment).
> 
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>


Acked-by: Arnd Bergmann <arnd@arndb.de>
