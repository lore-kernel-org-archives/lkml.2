Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874Ab1KQViS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 16:38:18 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36143 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144Ab1KQViR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 16:38:17 -0500
Date: Thu, 17 Nov 2011 13:38:14 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Greg KH <gregkh@suse.de>
cc: Claudio Scordino <claudio@evidence.eu.com>,
        Andrew Morton <akpm@linux-foundation.org>, viro@zeniv.linux.org.uk,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/base/node.c: fix compilation error
In-Reply-To: <20111117175210.GE13208@suse.de>
Message-ID: <alpine.DEB.2.00.1111171337020.15918@chino.kir.corp.google.com>
References: <4EC4DD20.6080201@evidence.eu.com> <20111117175210.GE13208@suse.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Nov 2011, Greg KH wrote:

> Is this a recent problem, or one that has been around for a long time
> (i.e. this fix should go to the -stable trees?)
> 

The equivalent patch for /proc/meminfo in the -mm tree, 
fs-proc-meminfoc-fix-compilation-error.patch, was cc'd to stable.  This 
one would have to go back to 2.6.38+.
