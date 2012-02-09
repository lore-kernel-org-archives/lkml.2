Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758540Ab2BITr3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 14:47:29 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:42737 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758515Ab2BITr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 14:47:28 -0500
Date: Thu, 9 Feb 2012 19:47:23 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Tang Liang <liang.tang@oracle.com>
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, konrad.wilk@oracle.com
Subject: Re: [PATCH 3/5] EFI: add efi driver for Xen efi
Message-ID: <20120209194723.GA8622@srcf.ucam.org>
References: <1328758250-23989-1-git-send-email-liang.tang@oracle.com>
 <1328758401-24258-1-git-send-email-liang.tang@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328758401-24258-1-git-send-email-liang.tang@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hm. Is there absolutely no way to do this by replacing efi_call_*? It'd 
really be nice to avoid yet another set of duplicate functions here - 
the ia64/x86 situation is already bad enough. Ideally this would be 
sufficiently generic that arm can also plug into it.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
