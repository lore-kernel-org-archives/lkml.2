Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896Ab2EFJEv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 05:04:51 -0400
Received: from smtp.tele.fi ([192.89.123.25]:55727 "EHLO smtp.tele.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752807Ab2EFJEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 05:04:50 -0400
X-Originating-Ip: [194.89.68.22]
Date: Sun, 6 May 2012 12:04:46 +0300
From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH] patches for v3.5-rc6.
Message-ID: <20120506090446.GU2058@reaktio.net>
References: <1336140267-7399-1-git-send-email-konrad.wilk@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336140267-7399-1-git-send-email-konrad.wilk@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 04, 2012 at 10:04:23AM -0400, Konrad Rzeszutek Wilk wrote:
> Was thinking to push these patches to Linus for v3.5-rc6.
> 

Hmm.. that probably should say for v3.4-rc6 ? :)

--  Pasi

>  arch/x86/xen/enlighten.c    |   40 ++++++++++++++++++++++++++++++++++++++--
>  arch/x86/xen/mmu.c          |    7 ++++++-
>  drivers/video/xen-fbfront.c |   25 +++++++++++++++----------
>  3 files changed, 59 insertions(+), 13 deletions(-)
> 
> David Vrabel (1):
>       xen/pci: don't use PCI BIOS service for configuration space accesses
> 
> Julia Lawall (1):
>       drivers/video/xen-fbfront.c: add missing cleanup code
> 
> Konrad Rzeszutek Wilk (2):
>       xen/apic: Return the APIC ID (and version) for CPU 0.
>       xen/pte: Fix crashes when trying to see non-existent PGD/PMD/PUD/PTEs
> 

