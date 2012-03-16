Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932497Ab2CPJKf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 05:10:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60611 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932408Ab2CPJKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 05:10:33 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1331868043.1971.10.camel@epip-laptop>
References: <1331868043.1971.10.camel@epip-laptop> <20120315205514.28759.58969.stgit@warthog.procyon.org.uk> <20120315205931.28759.81875.stgit@warthog.procyon.org.uk>
To: gxt@mprc.pku.edu.cn
Cc: dhowells@redhat.com, paul.gortmaker@windriver.com,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        arnd@arndb.de
Subject: Re: [PATCH 27/38] Disintegrate asm/system.h for Unicore32 [ver #3]
Date: Fri, 16 Mar 2012 09:10:18 +0000
Message-ID: <17897.1331889018@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guan Xuetao <gxt@mprc.pku.edu.cn> wrote:

> Great work!
> 
> Based on your patch, I adjusted some tiny bits and it could build
> successful now. Please see the following:

Do the upstream binutils and gcc support unicore32 targets?

David
