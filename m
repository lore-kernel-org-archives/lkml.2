Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928Ab2CDUgg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 15:36:36 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:47194 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754888Ab2CDUgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 15:36:35 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 4 Mar 2012 21:36:24 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: linux1394-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH]
Message-ID: <20120304213624.2dea61d7@stein>
In-Reply-To: <20120304213421.20560675@stein>
References: <20120304213421.20560675@stein>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mar 04 Stefan Richter wrote:
> CONFIG_FIREWIRE_OHCI_DEBUG could have been exposed to kernel tweakers
> if CONFIG_EXPERT was set.  But in hindsight, this stuff is far too
> useful to omit it.  So get rid of two #else branches that are only
> going to bitrot otherwise.

Sorry, this was meant to be sent with

    Subject: [PATCH] firewire: ohci: move runtime debug facility out of #ifdef
-- 
Stefan Richter
-=====-===-- --== --=--
http://arcgraph.de/sr/
