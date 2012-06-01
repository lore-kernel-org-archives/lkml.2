Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932557Ab2FANug (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 09:50:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64206 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759848Ab2FANuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 09:50:35 -0400
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
Date: Fri, 01 Jun 2012 14:50:31 +0100
Message-ID: <2284.1338558631@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 0000632e6472616f

That looks suspiciously like text.

00 \0
00 \0
63 c
2e .
64 d
72 t
61 a
6f f

David
