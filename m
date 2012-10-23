Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932721Ab2JWJCj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 05:02:39 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55877 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932503Ab2JWJCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 05:02:37 -0400
Date: Tue, 23 Oct 2012 02:02:32 -0700
From: Joel Becker <jlbec@evilplan.org>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Mark Fasheh <mfasheh@suse.com>, ocfs2-devel@oss.oracle.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/21] ocfs2: drop vmtruncate
Message-ID: <20121023090232.GA13027@localhost>
Mail-Followup-To: Marco Stornelli <marco.stornelli@gmail.com>,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>,
	Mark Fasheh <mfasheh@suse.com>, ocfs2-devel@oss.oracle.com,
	linux-kernel@vger.kernel.org
References: <508296B4.60508@gmail.com>
 <20121023085448.GM5635@localhost>
 <CANGUGtB0VR4hnRf5hk3_7Rc23fo5ejtj3J2yZZ50tD_Tk+sigw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANGUGtB0VR4hnRf5hk3_7Rc23fo5ejtj3J2yZZ50tD_Tk+sigw@mail.gmail.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 10:58:42AM +0200, Marco Stornelli wrote:
> 2012/10/23 Joel Becker <jlbec@evilplan.org>:
> > On Sat, Oct 20, 2012 at 02:19:00PM +0200, Marco Stornelli wrote:
> >> Removed vmtruncate
> >>
> >> Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
> >
> > Acked-by: Joel Becker <jlbec@evilplan.org>
> >
> > Do you want me to pull this, or are you going to send it with your set?
> >
> > Joel
> >
> 
> I'd prefer to push all via Al's tree since there is a VFS change.

SGTM.  Thanks!

Joel

> 
> Marco
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 

"In the long run...we'll all be dead."
                                        -Unknown

			http://www.jlbec.org/
			jlbec@evilplan.org
