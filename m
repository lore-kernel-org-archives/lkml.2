Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315Ab1EKUB0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 16:01:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34528 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752610Ab1EKUBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 16:01:25 -0400
Date: Wed, 11 May 2011 13:00:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Kumar Gala <galak@kernel.crashing.org>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>, Thomas Moll <thomas.moll@sysgo.com>
Subject: Re: [PATCH] RapidIO: Fix default routing initialization
Message-Id: <20110511130024.955f1981.akpm@linux-foundation.org>
In-Reply-To: <1305125163-14590-1-git-send-email-alexandre.bounine@idt.com>
References: <1305125163-14590-1-git-send-email-alexandre.bounine@idt.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 May 2011 10:46:03 -0400
Alexandre Bounine <alexandre.bounine@idt.com> wrote:

> Fix switch initialization to ensure that all switches have default
> routing disabled. This guarantees that no unexpected RapidIO packets
> arrive to the default port set by reset and there is no default routing
> destination until it is properly configured by software.
> 
> This update also unifies handling of unmapped destinations by tsi57x,
> IDT Gen1 and IDT Gen2 switches.

The changelog doesn't permit me to determine the importance of this fix,
so I don't know whether to schedule it for 2.6.39 or for -stable.

