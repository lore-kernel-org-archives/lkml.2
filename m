Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902Ab0CPTj1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 15:39:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1029 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755357Ab0CPTj0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 15:39:26 -0400
Date: Tue, 16 Mar 2010 20:37:50 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, andi@firstfloor.org,
       David Howells <dhowells@redhat.com>,
       Neil Horman <nhorman@tuxdriver.com>, Roland McGrath <roland@redhat.com>
Subject: [PATCH 0/4] do_coredump: cleanups
Message-ID: <20100316193750.GA31632@redhat.com>
References: <20100315122908.GB16175@hmsreliant.think-freely.org> <20100315194609.GA10896@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100315194609.GA10896@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15, Oleg Nesterov wrote:
>
> On 03/15, Neil Horman wrote:
> >
> > Hey, so I've rediffed and tested the user mode helper bits from my previous
> > patch set that got wrecked when the rcustring bits got pulled.
>
> More wrecked patches on top of Neil's refactoring.

And some more, this time in fs/exec.c.

do_coredump() is unreadable and needs cleanups.

Perhaps we should add the new helper which opens the file or pipe...

Oleg.

