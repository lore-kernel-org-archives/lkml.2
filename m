Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988Ab0G0JNX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 05:13:23 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:56908 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754115Ab0G0JNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 05:13:22 -0400
Date: Tue, 27 Jul 2010 11:13:20 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: David Howells <dhowells@redhat.com>
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild <linux-kbuild@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] frv: remove useless ARCHMODFLAGS assignment
Message-ID: <20100727091320.GA26235@merkur.ravnborg.org>
References: <20100726204312.GB18853@merkur.ravnborg.org> <20100726203814.GA18828@merkur.ravnborg.org> <13144.1280221225@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13144.1280221225@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 27, 2010 at 10:00:25AM +0100, David Howells wrote:
> Sam Ravnborg <sam@ravnborg.org> wrote:
> 
> > There is no references to ARCHMODLFAGS throughout the kernel tree.
> 
> Ummm...  Okay.  I guess modules don't work on FRV then.

We could change it to:
-ARCHMODFLAGS    += -G0 -mlong-calls
+KBUILD_MODFLAGS += -G0 -mlong-calls

Would this be better? 

	Sam
