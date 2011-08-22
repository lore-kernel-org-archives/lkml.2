Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466Ab1HVT3U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 15:29:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50978 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753189Ab1HVT3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 15:29:19 -0400
Date: Mon, 22 Aug 2011 12:28:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Kumar Gala <galak@kernel.crashing.org>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>, Thomas Moll <thomas.moll@sysgo.com>,
        Chul Kim <chul.kim@idt.com>, <stable@kernel.org>
Subject: Re: [PATCH] RapidIO: Fix use of non-compatible registers
Message-Id: <20110822122807.5b558d65.akpm@linux-foundation.org>
In-Reply-To: <1311703646-3453-1-git-send-email-alexandre.bounine@idt.com>
References: <1311703646-3453-1-git-send-email-alexandre.bounine@idt.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jul 2011 14:07:26 -0400
Alexandre Bounine <alexandre.bounine@idt.com> wrote:

> Replace/remove use of RIO v.1.2 registers/bits that are not forward-compatible
> with newer versions of RapidIO specification.
> 
> RapidIO specification v. 1.3 removed Write Port CSR, Doorbell CSR,
> Mailbox CSR and Mailbox and Doorbell bits of the PEF CAR.
> 
> Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
> Cc: Kumar Gala <galak@kernel.crashing.org>
> Cc: Matt Porter <mporter@kernel.crashing.org>
> Cc: Li Yang <leoli@freescale.com>
> Cc: Thomas Moll <thomas.moll@sysgo.com>
> Cc: Chul Kim <chul.kim@idt.com>
> Cc: <stable@kernel.org>

You did a cc:stable but provided no reason (that I can understand) for
backporting the patch.  Please explain why the problem is sufficiently
serious to warrant this action.
