Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758590Ab0FUVJu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 17:09:50 -0400
Received: from mail.openrapids.net ([64.15.138.104]:33299 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758566Ab0FUVJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 17:09:49 -0400
Date: Mon, 21 Jun 2010 17:09:46 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org
Cc: George Stephen-RVGG20 <RVGG20@freescale.com>,
       Martinez Ed-R12594 <R12594@freescale.com>
Subject: [RELEASE] LTTng 0.218 for kernel 2.6.34
Message-ID: <20100621210946.GA7449@Krystal>
References: <20100619154241.GA14460@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100619154241.GA14460@Krystal>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 17:08:41 up 149 days, 23:45,  4 users,  load average: 0.61, 0.37,
	0.26
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

LTTng 0.218 adds a missing irq_desc export in kernel/irq/handle.c, which only
affects sparse irq configurations. This omission only appeared in 0.217.

Mathieu

* Mathieu Desnoyers (mathieu.desnoyers@efficios.com) wrote:
> Hi,
> 
> I just released LTTng 0.217 for kernel 2.6.34. Enjoy! :-)
> 
> Mathieu
> 
> -- 
> Mathieu Desnoyers
> Operating System Efficiency R&D Consultant
> EfficiOS Inc.
> http://www.efficios.com

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
