Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755793Ab2DXPu2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 11:50:28 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52093 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755747Ab2DXPu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 11:50:26 -0400
Date: Tue, 24 Apr 2012 08:50:19 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, David Miller <davem@davemloft.net>,
        mmarek@suse.cz, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [GIT] modpost fix for newer toolchain
Message-ID: <20120424155019.GA8633@kroah.com>
References: <20120423184918.GA27862@sepie.suse.cz>
 <20120423192201.GA18512@merkur.ravnborg.org>
 <20120423201226.GA22593@kroah.com>
 <20120423.161353.876914987115892015.davem@davemloft.net>
 <20120423202248.GA24548@kroah.com>
 <20120423204735.GA18585@merkur.ravnborg.org>
 <CA+55aFyxktyAcni484Ti5gRe8ZqtF9LisTn3gRpLdJB4JWU-pg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyxktyAcni484Ti5gRe8ZqtF9LisTn3gRpLdJB4JWU-pg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2012 at 07:45:56PM -0700, Linus Torvalds wrote:
> On Mon, Apr 23, 2012 at 1:47 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
> >
> > I will mail stable when I have a commit-id - if no-one else does.
> 
> In my tree now. Commit e88aa7bbbe30.

Thanks, now applied to the 3.3-stable patch queue.

greg k-h
