Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769Ab0INWKw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 18:10:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51053 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752201Ab0INWKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 18:10:52 -0400
Date: Tue, 14 Sep 2010 15:10:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Thomas Moll <thomas.moll@sysgo.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>, Kumar Gala <galak@kernel.crashing.org>,
        Micha Nelissen <micha@neli.hopto.org>
Subject: Re: [PATCH v2 06/10] RapidIO: Modify sysfs initialization for
 switches
Message-Id: <20100914151026.4d9599b4.akpm@linux-foundation.org>
In-Reply-To: <1284476363-1677-7-git-send-email-alexandre.bounine@idt.com>
References: <1284476363-1677-1-git-send-email-alexandre.bounine@idt.com>
	<1284476363-1677-7-git-send-email-alexandre.bounine@idt.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Sep 2010 10:59:19 -0400
Alexandre Bounine <alexandre.bounine@idt.com> wrote:

> 1. Change to create attribute "routes" only for switches.

This is also a non-back compatible userspace-visible change?
