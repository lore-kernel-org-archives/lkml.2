Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761786Ab2CPObZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 10:31:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38262 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758476Ab2CPObY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 10:31:24 -0400
Message-ID: <4F634EA4.9070709@zytor.com>
Date: Fri, 16 Mar 2012 07:31:00 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Paul Eggert <eggert@cs.ucla.edu>
CC: "H.J. Lu" <hjl.tools@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        GNU C Library <libc-alpha@sourceware.org>
Subject: Re: x32 and width of blksize_t, suseconds_t
References: <20120315192515.GA6585@intel.com> <20120315195000.7E3BE2C0A3@topped-with-meat.com> <CAMe9rOpXRcO6a4cFEU=s1Gjzzt87zvyzuLhAWupc2pOX6az6ig@mail.gmail.com> <4F625570.7050003@cs.ucla.edu> <CAMe9rOpvnhPmpmsLedmOjjYB9SghZiov-cOUi+wrYvKaP+c9pQ@mail.gmail.com> <4F6267B1.3090805@cs.ucla.edu> <CAMe9rOrRdj_ns=rkonB2BwgmZa3KHBHTQQCv0bkH8PQ2UMXtHw@mail.gmail.com> <4F62F152.1040909@cs.ucla.edu> <4F62F786.2070907@cs.ucla.edu>
In-Reply-To: <4F62F786.2070907@cs.ucla.edu>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/2012 01:19 AM, Paul Eggert wrote:
> Come to think of it, the proposed x32 patch may have issues
> with blksize_t and suseconds_t as well.  POSIX says that an x32
> implementation must support at least one programming environment
> (presumably settable via a feature test macro) where blksize_t
> and suseconds_t are no wider than 'long'; see
> <http://pubs.opengroup.org/onlinepubs/9699919799/basedefs/sys_types.h.html>.
> But if I understand things correctly, x32 glibc would
> define these to be 'long long'.  This issue affects system
> calls such as 'stat' and 'select'.

That's just not going to happen, sorry.  Why on Earth is this a
requirement?  It makes no sense whatsoever.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

