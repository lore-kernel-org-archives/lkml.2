Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932998Ab1JZMtH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 08:49:07 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57543 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932917Ab1JZMtE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 08:49:04 -0400
References: <CAFkjPT=KcY=YH=Vy+ikyzEe26pwZ3RQ8T=pf+3oGvgECkX7sPw@mail.gmail.com> <CA+55aFyRpjKrjOkiwUDKb_madynN71neUzCjNVt-TPzsRbEcOQ@mail.gmail.com> <CAFkjPTkD+Ld8mhAdNZe_RbZaVZjDT+w61FhswzMQok3T2RbmYg@mail.gmail.com> <CA+55aFxQJBcdOqY_dekYiouVM_udb-4D2f_1n2WrGRdRfx=HPw@mail.gmail.com>
In-Reply-To: <CA+55aFxQJBcdOqY_dekYiouVM_udb-4D2f_1n2WrGRdRfx=HPw@mail.gmail.com>
Mime-Version: 1.0 (1.0)
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <FC179A32-61E1-4B40-AE58-724D255586F8@gmail.com>
Cc: V9FS Developers <v9fs-developer@lists.sourceforge.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
X-Mailer: iPad Mail (9A334)
From: Eric Van Hensbergen <ericvh@gmail.com>
Subject: Re: [GIT PULL] 9p changes fro merge window
Date: Wed, 26 Oct 2011 07:48:59 -0500
To: Linus Torvalds <torvalds@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Oct 26, 2011, at 7:28 AM, Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> Anyway, pulled now. I do wish people didn't rebase so much, it makes
> all the commits different in linux-next wrt what I actually end up
> getting..
> 

What's the preferred maintainer workflow?  I had been fetching and then rebasing, which seemed to keep my shortlog clean of merge commits and the outstanding patches towards the top.  Should I just be pulling from upstream and not caring about the merge commits?

Also, as a point of clarification, if I do get my kernel.org tree back, should I continue to sign tags for pull-requests or was that just for external repos like github?

         -eric