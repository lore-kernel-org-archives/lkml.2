Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812Ab0IBKsb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 06:48:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3834 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751022Ab0IBKsa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 06:48:30 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100902102153.19806.82031.stgit@warthog.procyon.org.uk>
References: <20100902102153.19806.82031.stgit@warthog.procyon.org.uk> <19747.1283422807@redhat.com>
Cc: dhowells@redhat.com, gerg@snapgear.com, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Drop a couple of unnecessary asm/include.h inclusions
Date: Thu, 02 Sep 2010 11:48:11 +0100
Message-ID: <20430.1283424491@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

> Drop inclusions of asm/include.h from linux/hardirq.h and linux/list.h as

asm/include.h should read asm/system.h here and in the subject.

David
