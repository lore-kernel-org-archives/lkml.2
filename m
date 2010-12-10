Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755731Ab0LJXW7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 18:22:59 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59678 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751404Ab0LJXW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 18:22:57 -0500
Date: Fri, 10 Dec 2010 15:22:33 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Kumar Gala <galak@kernel.crashing.org>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>, Thomas Moll <thomas.moll@sysgo.com>,
        Micha Nelissen <micha@neli.hopto.org>
Subject: Re: [PATCH -mm 4/4] RapidIO: Add new sysfs attributes
Message-Id: <20101210152233.3786b432.akpm@linux-foundation.org>
In-Reply-To: <1292013498-31406-5-git-send-email-alexandre.bounine@idt.com>
References: <1292013498-31406-1-git-send-email-alexandre.bounine@idt.com>
	<1292013498-31406-5-git-send-email-alexandre.bounine@idt.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Dec 2010 15:38:18 -0500
Alexandre Bounine <alexandre.bounine@idt.com> wrote:

> Add new sysfs attributes.

One would like to see documentation updates along with sysfs API
updates.  But one fears that this entire interface wasn't documented
anyway :(

Please at least fully describe the proposed interface in the changelog
so others can review the proposal.

The proposed new sysfs files appear to break the
one-value-per-sysfs-file rule.

