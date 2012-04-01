Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976Ab2DABqu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 21:46:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24552 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753482Ab2DABqr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 21:46:47 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20120331224452.1862a2b4@stein>
References: <20120331224452.1862a2b4@stein> <20120329153409.7295eda9@stein> <31597.1333222293@redhat.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: On patch "Remove all #inclusions of asm/system.h"
Date: Sun, 01 Apr 2012 02:46:31 +0100
Message-ID: <5679.1333244791@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

> It's not a problem; they now get barrier.h via spinlock.h.  I just
> wondered whether absence of #include <asm/barrier.h> in those files had a
> deeper non-obvious meaning.  Since it doesn't I will just put that include
> in them next time around when I do some housekeeping there.

I suspect they should #include asm/barrier.h directly rather than relying on
spinlock.h.  There's no guarantee that on every arch spinlock.h will pull in
asm/barrier.h, I think...

David
