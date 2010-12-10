Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755685Ab0LJXUB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 18:20:01 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39927 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754526Ab0LJXUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 18:20:00 -0500
Date: Fri, 10 Dec 2010 15:19:24 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>, Kumar Gala <galak@kernel.crashing.org>,
        Thomas Moll <thomas.moll@sysgo.com>,
        Micha Nelissen <micha@neli.hopto.org>
Subject: Re: [PATCH -mm 0/4] RapidIO: Misc updates
Message-Id: <20101210151924.333afed7.akpm@linux-foundation.org>
In-Reply-To: <1292013498-31406-1-git-send-email-alexandre.bounine@idt.com>
References: <1292013498-31406-1-git-send-email-alexandre.bounine@idt.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Dec 2010 15:38:14 -0500
Alexandre Bounine <alexandre.bounine@idt.com> wrote:

> The following four patches are follow-up to two RapidIO patches
> that are in the -mm tree now.
> 
> Alexandre Bounine (4):
>   RapidIO: Add definitions of Component Tag fields
>   RapidIO: Add device object linking into discovery
>   RapidIO: Use Component Tag for unified switch identification
>   RapidIO: Add new sysfs attributes
> 

I held
rapidio-use-common-destid-storage-for-endpoints-and-switches.patch and
rapidio-integrate-rio_switch-into-rio_dev.patch back from 2.6.37 due to
ongoing discussion.  What is the situation now?
