Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910Ab2DBFnQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 01:43:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51519 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752065Ab2DBFnO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 01:43:14 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1333312727-11428-9-git-send-email-paul.gortmaker@windriver.com>
References: <1333312727-11428-9-git-send-email-paul.gortmaker@windriver.com> <1333312727-11428-1-git-send-email-paul.gortmaker@windriver.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: dhowells@redhat.com, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: [PATCH 08/11] frv: fix warnings in mb93090-mb00/pci-dma.c about implicit EXPORT_SYMBOL
Date: Mon, 02 Apr 2012 06:43:06 +0100
Message-ID: <29844.1333345386@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Gortmaker <paul.gortmaker@windriver.com> wrote:

> To fix:
> 
> arch/frv/mb93090-mb00/pci-dma.c:31:1: warning: data definition has no type or storage class [enabled by default]
> arch/frv/mb93090-mb00/pci-dma.c:31:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL' [-Wimplicit-int]
> arch/frv/mb93090-mb00/pci-dma.c:31:1: warning: parameter names (without types) in function declaration [enabled by default]
> arch/frv/mb93090-mb00/pci-dma.c:38:1: warning: data definition has no type or storage class [enabled by default]
> 
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

Acked-by: David Howells <dhowells@redhat.com>
