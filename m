Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225Ab0LJP6m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 10:58:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6921 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756044Ab0LJP6l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 10:58:41 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1291850373-6955-1-git-send-email-peterhuewe@gmx.de>
References: <1291850373-6955-1-git-send-email-peterhuewe@gmx.de>
To: Peter Huewe <peterhuewe@gmx.de>
Cc: dhowells@redhat.com,
        Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Al Viro <viro@zeniv.linux.org.uk>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] avr32: Fix build failure conflicting types for 'sys_execve'
Date: Fri, 10 Dec 2010 15:58:06 +0000
Message-ID: <24086.1291996686@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Huewe <peterhuewe@gmx.de> wrote:

> This patch fixes a build failure[1] for the avr32 architecture which seems
> to be introduced by commit d7627467b7a8
> "Make do_execve() take a const filename pointer"
> 
> The commit changes the definition in arch/avr32/kernel/process.c but
> forgot to change it here.
> 
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>

Acked-by: David Howells <dhowells@redhat.com>
