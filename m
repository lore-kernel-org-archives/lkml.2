Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397Ab1EWADT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 20:03:19 -0400
Received: from smtp-out.google.com ([74.125.121.67]:13830 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754346Ab1EWADQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 20:03:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=pyisTxO5B2r6stuznxwDITLzy5TstbsQOrUbdSvgLPo75Zp20WZCYw1xIPv1QPMPPB
         ehPvvc1U6Q4HihYOoSPA==
Date: Sun, 22 May 2011 17:03:08 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Hugh Dickins <hughd@google.com>, Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: Adding an ugliness in __read_cache_page()?
In-Reply-To: <BANLkTimpi2vhx3NzR71G640HXXn-keCoqQ@mail.gmail.com>
Message-ID: <alpine.LSU.2.00.1105221702150.1427@sister.anvils>
References: <alpine.LSU.2.00.1105221518180.17400@sister.anvils> <BANLkTimpi2vhx3NzR71G640HXXn-keCoqQ@mail.gmail.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323584-143352963-1306108997=:1427"
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323584-143352963-1306108997=:1427
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Sun, 22 May 2011, Linus Torvalds wrote:
> On Sun, May 22, 2011 at 3:25 PM, Hugh Dickins <hughd@google.com> wrote:
> >
> > Would it be better to make i915 and ttm call shmem_read_cache_page()
> > directly? =A0Perhaps removing the then unused read_cache_page_gfp(), or
> > perhaps not: may still be needed for i915 and ttm on tiny !SHMEM ramfs.
>=20
> I would certainly prefer the "make i915 and ttm call
> shmem_read_cache_page directly" approach over putting some nasty hack
> in __read_cache_page.

Thank you: I'll go that way.

Hugh
--8323584-143352963-1306108997=:1427--
