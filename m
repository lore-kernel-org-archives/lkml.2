Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381Ab0ICGso (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 02:48:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61177 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752828Ab0ICGsm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 02:48:42 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100903014042.GH2684@bombadil.infradead.org>
References: <20100903014042.GH2684@bombadil.infradead.org> <20100827015905.27277.39167.stgit@warthog.procyon.org.uk> <20100827020043.27277.2926.stgit@warthog.procyon.org.uk>
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: dhowells@redhat.com, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 19/22] Fix PA-RISC irqflags
Date: Fri, 03 Sep 2010 07:48:27 +0100
Message-ID: <7137.1283496507@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle McMartin <kyle@mcmartin.ca> wrote:

> Should I merge this, or are you going to push this with some larger
> changes?

This will need to be merged into the main patch before that is submitted, but
if I can have your Acked-by, I can include that specifically for the PA-RISC
bits.

David
