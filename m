Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684Ab0KPS0A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 13:26:00 -0500
Received: from canuck.infradead.org ([134.117.69.58]:40880 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754742Ab0KPSZ6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 13:25:58 -0500
Subject: Re: [RFC][PATCH v2] irq_work: Drop cmpxchg result
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Sergio Aguirre <saaguirre@ti.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Huang Ying <ying.huang@intel.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Kyle McMartin <kyle@mcmartin.ca>
In-Reply-To: <1289930567-17828-1-git-send-email-saaguirre@ti.com>
References: <1289930567-17828-1-git-send-email-saaguirre@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 16 Nov 2010 19:26:08 +0100
Message-ID: <1289931968.2109.649.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-16 at 12:02 -0600, Sergio Aguirre wrote:
> This solves this compilation warning:
> 
> kernel/irq_work.c: In function 'irq_work_run':
> kernel/irq_work.c:148: warning: value computed is not used
> 
Thanks!
