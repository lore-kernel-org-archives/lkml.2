Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785Ab2K0VJP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 16:09:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22752 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753711Ab2K0VJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 16:09:11 -0500
Message-ID: <1354050541.2849.8.camel@localhost>
Subject: Re: linux-next: Tree for Nov 27 (file notify)
From: Eric Paris <eparis@redhat.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Eric Paris <eparis@parisplace.org>
Date: Tue, 27 Nov 2012 16:09:01 -0500
In-Reply-To: <50B4EDBF.8070304@infradead.org>
References: <20121127172548.cd502ebfb903face1dc98554@canb.auug.org.au>
	 <50B4EDBF.8070304@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-11-27 at 08:43 -0800, Randy Dunlap wrote:
> On 11/26/2012 10:25 PM, Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > Changes since 20121126:
> > 
> 
> 
> when CONFIG_PROC_FS is not enabled (also seen in mmotm):
> 
> fs/notify/fanotify/fanotify_user.c:436:17: error: 'fanotify_show_fdinfo' undeclared here (not in a function)
> fs/notify/inotify/inotify_user.c:333:17: error: 'inotify_show_fdinfo' undeclared here (not in a function

It is something coming in from Andrew's tree.  I believe they already
have a patch.

-Eric

