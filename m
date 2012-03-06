Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031599Ab2CFXT6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 18:19:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42968 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031454Ab2CFXT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 18:19:56 -0500
Date: Tue, 6 Mar 2012 15:19:54 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kinsbursky Stanislav <skinsbursky@openvz.org>
Cc: "jmorris@namei.org" <jmorris@namei.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "criu@openvz.org" <criu@openvz.org>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "eparis@parisplace.org" <eparis@parisplace.org>,
        "sds@tycho.nsa.gov" <sds@tycho.nsa.gov>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [CRIU] [PATCH 0/5] IPC: checkpoint/restore in userspace
 enhancements
Message-Id: <20120306151954.bc50817c.akpm@linux-foundation.org>
In-Reply-To: <4F54B9DE.60604@openvz.org>
References: <20120209175043.24392.62810.stgit@localhost6.localdomain6>
	<4F54B9DE.60604@openvz.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 05 Mar 2012 17:04:30 +0400
Kinsbursky Stanislav <skinsbursky@openvz.org> wrote:

> 09.02.2012 22:01, Stanislav Kinsbursky __________:
> > This patch set aimed to provide additional functionality for all IPC objects,
> > which is required for migration these objects by user-space checkpoint/restore
> > utils.
> > The main problem here was impossibility to set up object id. This patch set
> > solves the problem in two steps:
> > 1) Makes it possible to create new object (shared memory, semaphores set or
> > messages queue) with ID, equal to passed key.
> > 2) Makes it possible to change existent object key.
>
> Hello, Andrew.
> Are you going to take this patch set?
> 

(top-posting repaired - please don't do that)

I haven't forgotten about it :(.  There has been little review feedback
on this patchset and I still have overall concerns about the approach
we've been taking to c/r development.  I have a lengthy Feb 15 email
from Pavel which I also haven't forgotten about, but I haven't got back
to thinking about the whole topic yet, sorry.  Soon...
