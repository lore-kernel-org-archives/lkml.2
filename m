Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804Ab1FIGQY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 02:16:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18716 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751198Ab1FIGQX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 02:16:23 -0400
Date: Thu, 9 Jun 2011 08:15:48 +0200 (CEST)
From: Lukas Czerner <lczerner@redhat.com>
X-X-Sender: lukas@dhcp-27-109.brq.redhat.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Lukas Czerner <lczerner@redhat.com>, linux-kernel@vger.kernel.org,
        Eric Paris <eparis@redhat.com>, linux-security-module@vger.kernel.org
Subject: Re: NULL pointer dereference in inode_has_perm() while setquota
In-Reply-To: <20110608134014.43ac448b.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.2.00.1106090815020.4138@dhcp-27-109.brq.redhat.com>
References: <alpine.LFD.2.00.1106011019050.13985@dhcp-27-109.brq.redhat.com> <20110608134014.43ac448b.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Jun 2011, Andrew Morton wrote:

> On Wed, 1 Jun 2011 10:35:51 +0200 (CEST)
> Lukas Czerner <lczerner@redhat.com> wrote:
> 
> > I was running xfstests on ext4 filesystem and I have run into NULL
> > pointer dereference in inode_has_perm() while running test no. 234. This
> > is on kernel 3.0.0-rc1.
> 
> Is this a regression?  Was 2.6.39 OK?
> 
> Thanks.
> 

I suppose, since I have never seen that bug before, however I am going
to retest.

Thanks!
-Lukas
