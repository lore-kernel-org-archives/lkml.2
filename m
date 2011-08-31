Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034Ab1HaKP4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 06:15:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61899 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752073Ab1HaKPy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 06:15:54 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20110826220311.GA18140@fieldses.org>
References: <20110826220311.GA18140@fieldses.org> <1312810169.2591.1153.camel@deadeye> <20110808155538.GB904@fieldses.org> <20110808180658.GC29924@decadent.org.uk>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: dhowells@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
        Ben Hutchings <ben@decadent.org.uk>, Neil Brown <neilb@suse.de>,
        linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH] All Arch: remove linkage for sys_nfsservctl system call
Date: Wed, 31 Aug 2011 11:15:04 +0100
Message-ID: <27331.1314785704@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

J. Bruce Fields <bfields@fieldses.org> wrote:

> From: NeilBrown <neilb@suse.de>
> 
> The nfsservctl system call is now gone, so we should remove all
> linkage for it.
> 
> Signed-off-by: NeilBrown <neilb@suse.de>
> Signed-off-by: J. Bruce Fields <bfields@redhat.com>

Acked-by: David Howells <dhowells@redhat.com> [FRV/MN10300]
