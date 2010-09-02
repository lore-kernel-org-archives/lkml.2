Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243Ab0IBPML (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 11:12:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59549 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753808Ab0IBPMI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 11:12:08 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <m38w3kns4r.fsf@hase.home>
References: <m38w3kns4r.fsf@hase.home> <19747.1283422807@redhat.com> <20100902102158.19806.14133.stgit@warthog.procyon.org.uk>
To: Andreas Schwab <schwab@redhat.com>
Cc: dhowells@redhat.com, gerg@snapgear.com, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] M68K: Use CONFIG_MMU not __uClinux__ to select m68knommu contributions
Date: Thu, 02 Sep 2010 16:11:52 +0100
Message-ID: <24053.1283440312@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Schwab <schwab@redhat.com> wrote:

> > Use CONFIG_MMU not __uClinux__ to select m68knommu contributions as
> > nothing in the arch defines __uClinux__ for the build.
> 
> You are using the wrong compiler.

It's the only m68k compiler that I've got.

David
