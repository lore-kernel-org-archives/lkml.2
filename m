Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934Ab0ELBjY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 21:39:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5200 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752107Ab0ELBjT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 21:39:19 -0400
Date: Wed, 12 May 2010 02:39:09 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] fix hard-coded disk header chunk size for persistent
	snapshot
Message-ID: <20100512013909.GD2377@agk-dp.fab.redhat.com>
Mail-Followup-To: Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>,
	dm-devel@redhat.com, linux-kernel@vger.kernel.org,
	Mikulas Patocka <mpatocka@redhat.com>
References: <4BEA0472.1060300@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BEA0472.1060300@jp.fujitsu.com>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 1TE.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 12, 2010 at 10:29:22AM +0900, Tomohiro Kusumi wrote:
> This patch fixes hard-coded value for the size of a chunk that includes
> disk header for persistent snapshot. It should be changed to existing
> macro NUM_SNAPSHOT_HDR_CHUNKS instead of using hard-coded value 1.
 
Any more places too?  (E.g. persistent_commit_merge)

Alasdair

