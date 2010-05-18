Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756845Ab0ERGjX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 02:39:23 -0400
Received: from mail.sysgo.com ([195.145.229.155]:42413 "EHLO mail.sysgo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755807Ab0ERGjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 02:39:21 -0400
Date: Tue, 18 May 2010 08:28:16 +0200
From: Thomas Moll <thomas.moll@sysgo.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
       alexandre.bounine@idt.com, mporter@kernel.crashing.org,
       leoli@freescale.com, galak@kernel.crashing.org
Subject: [PATCH 0/1] RapidIO: Fix maintenance access to higher memory areas
Message-Id: <20100518082816.900554d5.thomas.moll@sysgo.com>
In-Reply-To: <1272901558-9292-1-git-send-email-alexandre.bounine@idt.com>
References: <1272901558-9292-1-git-send-email-alexandre.bounine@idt.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following RapidIO patch is applicable to the latest kernel tree with applied RapidIO patches from Alexandre Bounine. The modification is required for IDT CPS switch devices which will access these memory areas, to setup 16bit routing.
