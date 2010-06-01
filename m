Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757056Ab0FAPrp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 11:47:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19960 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756656Ab0FAPrn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 11:47:43 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100530075927.GA4912@hera.kernel.org>
References: <20100530075927.GA4912@hera.kernel.org>
To: Denis Kirjanov <dkirjanov@hera.kernel.org>
Cc: dhowells@redhat.com, linux-afs@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] afs: fix possible null pointer dereference in afs_alloc_server
Date: Tue, 01 Jun 2010 16:47:11 +0100
Message-ID: <31814.1275407231@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Denis Kirjanov <dkirjanov@hera.kernel.org> wrote:

> Fix possible null pointer dereference since kzalloc can return null

This should really be merged into the preceding if-statement.

David
