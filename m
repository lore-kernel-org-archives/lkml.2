Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896Ab1BXIFA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 03:05:00 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:39054 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754504Ab1BXIE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 03:04:59 -0500
X-Authenticated: #23875046
X-Provags-ID: V01U2FsdGVkX19PbfEpJ6lPtYgOoT948fmaggviXrrg1by1P2AjsF
	PZWjAjzKi/TaxE
Subject: Re: [PATCH 2/2 v2] Unify rest of FAT messages.
From: Alexey Fisher <bug-track@fisher-privat.net>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org, joe@perches.com
In-Reply-To: <8739r8q4s3.fsf@devron.myhome.or.jp>
References: <1289321718-6373-1-git-send-email-bug-track@fisher-privat.net>
	 <1289329470-14454-1-git-send-email-bug-track@fisher-privat.net>
	 <87hbfppfu3.fsf@devron.myhome.or.jp> <1289392908.6057.44.camel@zwerg>
	 <87d3qdp9oa.fsf@devron.myhome.or.jp> <1289401644.2438.34.camel@mini>
	 <878w11p1wk.fsf@devron.myhome.or.jp> <1289408312.3636.10.camel@mini>
	 <8739r8q4s3.fsf@devron.myhome.or.jp>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Feb 2011 09:04:52 +0100
Message-ID: <1298534692.6569.0.camel@mini>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

are there any updates on this issue?

Am Donnerstag, den 11.11.2010, 05:53 +0900 schrieb OGAWA Hirofumi:
> Alexey Fisher <bug-track@fisher-privat.net> writes:
> 
> >> Also, yes. It would be complicate more or less than one FS. And maybe I
> >> can understand why you want to concentrate FAT.
> >> 
> >> But I'm afraid to implement for only FAT. If there is not any some sort
> >> of agreement by others, it may have to re-implement. If that happen, FAT
> >> can be bothered by compatible (or have to maintain both of old and new
> >> for a while). Because the notified data are some sort of ABI, IMO.
> >> 
> >> This is why I'm careful about this, and can't say easily - "let's try it
> >> on FAT".
> >
> > I'm not sure if we talk about same thing now :D
> > By notification you mean the idea to notify userspace about error?
> > correct?
> 
> Sure. I was talking about "to notify userspace". :)
> 
> > In my previous email i switched the point, it will be to complicate for
> > now to work on notification system. For now i'll be happy to see grep
> > friendly logs. Same like ext2,3,4 do
> >
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=4cf46b67eb6de94532c1bea11d2479d085229d0e
> >
> > In long term it will be good to have such notification system. So i will
> > start new tread about it. 
> 
> OK, I see. I'll review patches. Looks good though.
> 
> Thanks.


