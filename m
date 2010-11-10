Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547Ab0KJPH2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 10:07:28 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:53156 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1756475Ab0KJPH1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 10:07:27 -0500
X-Authenticated: #23875046
X-Provags-ID: V01U2FsdGVkX1+sHRwisEyskWFQZMbrzzur/5BCMRdiDY1aooEwN9
	7j3KKiGCUbi228
Subject: Re: [PATCH 2/2 v2] Unify rest of FAT messages.
From: Alexey Fisher <bug-track@fisher-privat.net>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org, joe@perches.com
In-Reply-To: <87d3qdp9oa.fsf@devron.myhome.or.jp>
References: <1289321718-6373-1-git-send-email-bug-track@fisher-privat.net>
	 <1289329470-14454-1-git-send-email-bug-track@fisher-privat.net>
	 <87hbfppfu3.fsf@devron.myhome.or.jp> <1289392908.6057.44.camel@zwerg>
	 <87d3qdp9oa.fsf@devron.myhome.or.jp>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Nov 2010 16:07:24 +0100
Message-ID: <1289401644.2438.34.camel@mini>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, den 10.11.2010, 22:53 +0900 schrieb OGAWA Hirofumi:
> Alexey Fisher <bug-track@fisher-privat.net> writes:
> 
> > Am Mittwoch, den 10.11.2010, 20:40 +0900 schrieb OGAWA Hirofumi:
> >> Alexey Fisher <bug-track@fisher-privat.net> writes:
> >> 
> >> > Here is how it looks like after patch.
> >> 
> >> This is going to unify the all FSes (e.g. fat_msg() uses fs_msg("FAT", ...))?
> >> If so, I think it's welcome. If not, umm, it looks like good but...
> >
> > Yea, i thought about it. It will be better to have some kernel wide
> > fs_msg(). But before doing this i think one more step should be done -
> > some notification interface for userspace. 
> > If we get some fs errors userspace app should be notified so user too.
> >
> > I work currently on one case, user lost all data on FAT drive. First
> > error messages was logged for some weeks, and only now some big data
> > lost. There war no errors from GUI.
> 
> It clealy can happen on all FSes, not only FAT. And I don't want to push
> it (notification stuff) from FAT tree. (need the review from other guys).

I do not blame FAT. It was just one example/usecase.

> IMHO, it should be kernel wide (or subsystem wide) notification system
> even if you target is FAT-fs only.  (yeah, it's hard to push to
> linus-tree than one FS though).

Sound complicated. I will not get time for this, right now. Any way, at
least if this patch set go upstream it will help investigate some FS
related issues. For my work (Computer Forensic) it will be really
helpful.

Regards,
Alexey


