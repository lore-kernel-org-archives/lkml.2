Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674Ab2JIJiz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 05:38:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30801 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751440Ab2JIJiw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 05:38:52 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <506FF10A.8030600@monstr.eu>
References: <506FF10A.8030600@monstr.eu> <17386.1349380289@warthog.procyon.org.uk>
To: monstr@monstr.eu
Cc: dhowells@redhat.com, microblaze-uclinux@itee.uq.edu.au,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Disintegrate UAPI for microblaze
Date: Tue, 09 Oct 2012 10:38:47 +0100
Message-ID: <21958.1349775527@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Simek <monstr@monstr.eu> wrote:

> I expect your intention is to merge this to mainline in current merge
> window, right?

It is preferred that it go through the maintainer's tree if possible.  Note
that I've posted a new version that doesn't have the dependencies any more as
they've been merged upstream.

David
