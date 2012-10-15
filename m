Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060Ab2JOMVD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 08:21:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18839 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752972Ab2JOMVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 08:21:00 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <507BFE70.9020601@metafoo.de>
References: <507BFE70.9020601@metafoo.de> <20121015114343.1042.81528.stgit@warthog.procyon.org.uk> <20121015114404.1042.75225.stgit@warthog.procyon.org.uk>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
        Fengguang Wu <fengguang.wu@intel.com>, uclinux-dev@uclinux.org
Subject: Re: [PATCH 4/4] FRV: Fix linux/elf-fdpic.h
Date: Mon, 15 Oct 2012 13:20:47 +0100
Message-ID: <25464.1350303647@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lars-Peter Clausen <lars@metafoo.de> wrote:

> The second part of the patch adding it back to include/linux/elf-fdpic.h
> seems to be missing.

Oops.  Yes.  I forgot to 'stg add' it.

David
