Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754922Ab0IHOfq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 10:35:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65407 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751323Ab0IHOfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 10:35:45 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1283888011.7250.17.camel@odc-laptop>
References: <1283888011.7250.17.camel@odc-laptop>
To: david.cross@cypress.com
Cc: dhowells@redhat.com, linux-cachefs@redhat.com, greg@kroah.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Cachefiles, mpage_cleardirty addtition, west bridge related
Date: Wed, 08 Sep 2010 15:35:31 +0100
Message-ID: <4313.1283956531@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Cross <david.cross@cypress.com> wrote:

> This patch adds the mpage_cleardirty function to the cachefiles implementation in the kernel.

Ummm...  How is this used by cachefiles?  Nothing in this patch actually uses
mpage_cleardirty().

David
