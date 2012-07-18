Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717Ab2GRFxo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 01:53:44 -0400
Received: from edison.jonmasters.org ([173.255.233.168]:54315 "EHLO
	edison.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036Ab2GRFxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 01:53:36 -0400
Message-ID: <50064F5E.108@jonmasters.org>
Date: Wed, 18 Jul 2012 01:53:34 -0400
From: Jon Masters <jonathan@jonmasters.org>
Organization: World Organi{s,z}ation of Broken Dreams
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Will Deacon <will.deacon@arm.com>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com> <1341608777-12982-3-git-send-email-catalin.marinas@arm.com>
In-Reply-To: <1341608777-12982-3-git-send-email-catalin.marinas@arm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
Subject: Re: [PATCH 02/36] ipc: Add COMPAT_SHMLBA support
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Nov 2009 07:31:22 +0000)
X-SA-Exim-Scanned: Yes (on edison.jonmasters.org)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/06/2012 05:05 PM, Catalin Marinas wrote:

> The reason for this patch is that we want SHMLBA to be 64K on AArch64

Presumably this is to obviate differences between 64K or 4K pages?

Jon.
