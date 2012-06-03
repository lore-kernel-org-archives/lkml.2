Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602Ab2FCTrd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 15:47:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:47256 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754054Ab2FCTrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 15:47:33 -0400
Message-ID: <1338752840.2448.37.camel@twins>
Subject: Re: [PATCH] Fix booted_cores calculation in set_cpu_sibling_map()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org
Date: Sun, 03 Jun 2012 21:47:20 +0200
In-Reply-To: <1338658674-6550-1-git-send-email-prarit@redhat.com>
References: <1338658674-6550-1-git-send-email-prarit@redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

http://marc.info/?l=linux-kernel&m=133849647709656
