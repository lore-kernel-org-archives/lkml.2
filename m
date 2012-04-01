Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789Ab2DAVaU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 17:30:20 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:63563 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369Ab2DAVaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 17:30:19 -0400
Date: Mon, 2 Apr 2012 00:30:13 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "drepper@gmail.com" <drepper@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] nextfd(2)
Message-ID: <20120401213013.GA4408@p183.telecom.by>
References: <20120401125741.GA7484@p183.telecom.by>
 <4F785F1D.4020503@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F785F1D.4020503@openvz.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 01, 2012 at 05:58:53PM +0400, Konstantin Khlebnikov wrote:
> Alexey Dobriyan wrote:

> > So, don't add closefrom(2), add nextfd(2).
> >
> > 	int nextfd(int fd)
> 
> Can we add "pid" argument to be able to search next fd in other task?
> Together with sys_kcmp() this will be very useful for checkpoint/restore.

You've added /proc/*/map_files for C/R making proc mandatory,
so you do have /proc/*/fd .
