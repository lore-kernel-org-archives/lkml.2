Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576Ab2CEP6k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 10:58:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16265 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753654Ab2CEP6j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 10:58:39 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1330088295-28732-1-git-send-email-joerg.roedel@amd.com>
References: <1330088295-28732-1-git-send-email-joerg.roedel@amd.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Arnd Bergmann <arnd@arndb.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] bitops: Add missing parentheses to new get_order macro
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Date: Mon, 05 Mar 2012 15:58:26 +0000
Message-ID: <21621.1330963106@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel <joerg.roedel@amd.com> wrote:

> The new get_order macro introcuded in commit
> 
> 	d66acc39c7cee323733c8503b9de1821a56dff7e
> 
> does not use parentheses around all uses of the parameter n.
> This causes new compile warnings, for example in the
> amd_iommu_init.c function:
> 
> drivers/iommu/amd_iommu_init.c:561:6: warning: suggest parentheses around comparison in operand of ‘&’ [-Wparentheses]
> drivers/iommu/amd_iommu_init.c:561:6: warning: suggest parentheses around comparison in operand of ‘&’ [-Wparentheses]
> 
> Fix those warnings by adding the missing parentheses.
> 
> Reported-by: Ingo Molnar <mingo@elte.hu>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>

Acked-by: David Howells <dhowells@redhat.com>
