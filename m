Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322Ab0LOUfu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 15:35:50 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:59118 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751081Ab0LOUfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 15:35:44 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/+TdctlX3+sV5lTZu9qs5GroAfd0iIMsAZ0/55fe
	R1KshyvrTYExp+
From: Peter =?iso-8859-15?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Matthew Garrett <mjg@redhat.com>
Subject: Re: [PATCH] platform/x86: Fix recursive Kconfig dependency
Date: Wed, 15 Dec 2010 21:35:35 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36.2; KDE/4.4.5; x86_64; ; )
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1291850970-7190-1-git-send-email-peterhuewe@gmx.de>
In-Reply-To: <1291850970-7190-1-git-send-email-peterhuewe@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201012152135.35941.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag 09 Dezember 2010, 00:29:30 schrieb Peter Huewe:
> This patch removes a recursive dependency which causes a build failure
> [1-3] by changing the ASUS_WMI from select ACPI_WMI to depend on
> ACPI_WMI as most other _WMI config options do.
> 
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
> ---
> Error Message:
> drivers/platform/x86/Kconfig:422:error: recursive dependency detected!
> drivers/platform/x86/Kconfig:422:	symbol EEEPC_WMI depends on ACPI_WMI
> drivers/platform/x86/Kconfig:438:	symbol ACPI_WMI is selected by ACER_WMI
> drivers/platform/x86/Kconfig:18:	symbol ACER_WMI depends on LEDS_CLASS
> drivers/leds/Kconfig:10:	symbol LEDS_CLASS is selected by EEEPC_WMI
> 
> 
> References:
> [1] http://kisskb.ellerman.id.au/kisskb/buildresult/3607123/
> [2] http://kisskb.ellerman.id.au/kisskb/buildresult/3607218/
> [3] http://kisskb.ellerman.id.au/kisskb/buildresult/3607139/
> 
> KernelVersion: linux-next-20101208
> 


Ping - Any updates yet ?
