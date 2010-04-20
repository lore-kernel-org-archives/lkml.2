Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606Ab0DTMuJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 08:50:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6239 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754566Ab0DTMuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 08:50:06 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1271766546.25129.76.camel@localhost.localdomain>
References: <1271766546.25129.76.camel@localhost.localdomain> <1271698361.13653.79.camel@localhost.localdomain> <14317.1271691185@redhat.com> <32174.1271753314@redhat.com>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: dhowells@redhat.com, paulmck@linux.vnet.ibm.com, linux-nfs@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: RCU-isms in fs/nfs/delegation.c
Date: Tue, 20 Apr 2010 13:49:59 +0100
Message-ID: <1170.1271767799@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trond Myklebust <Trond.Myklebust@netapp.com> wrote:

> Agreed. Thanks for the review...

The version of the patch I posted just before lunch is hopefully fixed
correctly.

David
