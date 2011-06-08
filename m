Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076Ab1FHUkv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 16:40:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36215 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751141Ab1FHUkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 16:40:49 -0400
Date: Wed, 8 Jun 2011 13:40:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lukas Czerner <lczerner@redhat.com>
Cc: linux-kernel@vger.kernel.org, Eric Paris <eparis@redhat.com>,
        linux-security-module@vger.kernel.org
Subject: Re: NULL pointer dereference in inode_has_perm() while setquota
Message-Id: <20110608134014.43ac448b.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1106011019050.13985@dhcp-27-109.brq.redhat.com>
References: <alpine.LFD.2.00.1106011019050.13985@dhcp-27-109.brq.redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Jun 2011 10:35:51 +0200 (CEST)
Lukas Czerner <lczerner@redhat.com> wrote:

> I was running xfstests on ext4 filesystem and I have run into NULL
> pointer dereference in inode_has_perm() while running test no. 234. This
> is on kernel 3.0.0-rc1.

Is this a regression?  Was 2.6.39 OK?

Thanks.
