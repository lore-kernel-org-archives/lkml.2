Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758823Ab0EDQ0N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 12:26:13 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56743 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757089Ab0EDQ0L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 12:26:11 -0400
Subject: Re: [PATCH 2/2] lockdep: allow user to disable
 CONFIG_TRACE_IRQFLAGS
From: Peter Zijlstra <peterz@infradead.org>
To: tom.leiming@gmail.com
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <1272988944-2448-1-git-send-email-tom.leiming@gmail.com>
References: <1272988944-2448-1-git-send-email-tom.leiming@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 04 May 2010 18:26:05 +0200
Message-ID: <1272990365.5605.215.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-05 at 00:02 +0800, tom.leiming@gmail.com wrote:
> There is still the lost irq-on tracing issue on ARM,
> (see http://marc.info/?l=linux-arm-kernel&m=126047420005553&w=2)
> which may disable lockdep after kernel boot, seems no
> good solution for the issue up to now. 

Well, do like x86 does in entry.S call into lockdep right before
returning to userspace.


