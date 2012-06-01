Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760003Ab2FAO0L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 10:26:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30894 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759031Ab2FAO0K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 10:26:10 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20120601034114.GA9248@localhost>
References: <20120601034114.GA9248@localhost>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: dhowells@redhat.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: BUG in __key_instantiate_and_link(): unable to handle kernel paging request at 0000632e6472616f
Date: Fri, 01 Jun 2012 15:24:51 +0100
Message-ID: <2998.1338560691@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fengguang Wu <fengguang.wu@intel.com> wrote:

> It's the second time the machine oops in __key_instantiate_and_link() on
> 3.4 kernel.  This bug only happens after several days of run. Do you
> have any advices or debug patches? For now I can try older (or newer)
> kernels and see if it's any better.

You should send this to the NFS list too.  The problem might be in the
idmapper code.

David
