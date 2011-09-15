Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933148Ab1IOLAV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 07:00:21 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38094 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932575Ab1IOLAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 07:00:19 -0400
Date: Thu, 15 Sep 2011 15:00:11 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Pavel Machek <pavel@ucw.cz>, Andrew Morton <akpm00@gmail.com>,
        linux-kernel@vger.kernel.org, containers@lists.osdl.org,
        linux-fsdevel@vger.kernel.org, Kirill Shutemov <kirill@shutemov.name>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Nathan Lynch <ntl@pobox.com>, Zan Lynx <zlynx@acm.org>,
        Daniel Lezcano <dlezcano@fr.ibm.com>, Tejun Heo <tj@kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 2/2] fs, proc: Introduce the /proc/<pid>/map_files/
 directory v12
Message-ID: <20110915110010.GD27755@sun>
References: <20110914111437.GA22516@atrey.karlin.mff.cuni.cz>
 <20110914113912.GQ25367@sun>
 <20110914134405.GV25367@sun>
 <20110914144841.GA7906@albatros>
 <20110914160018.GW25367@sun>
 <20110914160724.GA10612@albatros>
 <20110915091417.GA27755@sun>
 <20110915092757.GA23404@albatros>
 <20110915102922.GB27755@sun>
 <20110915105651.GA17575@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110915105651.GA17575@albatros>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 15, 2011 at 02:56:51PM +0400, Vasiliy Kulikov wrote:
...
> > > 
> > > How can you restore a set of processes in case they share an RW mapping
> > > as RW in both tasks if you deny opening /proc/$pid/map_files/$address as W?
> > 
> > I can read the link first to figure out the file path and re-open it as rw via
> > path itself (which implies the restorer still must have enough rights to open
> > it as rw).
> 
> And what about RW mapping of unlinked files?
> 

Need to figure some workaround

	Cyrill
