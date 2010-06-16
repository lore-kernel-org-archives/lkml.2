Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932612Ab0FPSt2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 14:49:28 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55712 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932582Ab0FPSt0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 14:49:26 -0400
Subject: Re: [PATCH 2/6: v4] lockdep: Make MAX_STACK_TRACE_ENTRIES
 configurable.
From: Peter Zijlstra <peterz@infradead.org>
To: John Kacur <jkacur@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, lkml <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       Clark Williams <williams@redhat.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1276554087-3632-3-git-send-email-jkacur@redhat.com>
References: <1276554087-3632-1-git-send-email-jkacur@redhat.com>
	 <1276554087-3632-3-git-send-email-jkacur@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 16 Jun 2010 20:49:14 +0200
Message-ID: <1276714154.1745.623.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-15 at 00:21 +0200, John Kacur wrote:
> Certain debug configurations that have LOCKDEP turned on, run into the limit
> where the MAX_STACK_TRACE_ENTRIES are too small. Rather than simply turning
> off the locking correctness validator, let the user configure this value
> to something reasonable for their system.
> 
> This patch was generated against 2.6.33.5-rt23 but is also intended to be
> picked-up for mainline.

NACK

patches like 4726f2a617ebd868a4fdeb5679613b897e5f1676 are the way to go.
