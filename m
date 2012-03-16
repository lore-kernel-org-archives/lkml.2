Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715Ab2CPTRA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 15:17:00 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:37715 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755010Ab2CPTQ6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 15:16:58 -0400
MIME-Version: 1.0
In-Reply-To: <4F638C5C.6080507@cs.ucla.edu>
References: <20120315192515.GA6585@intel.com>
	<20120315195000.7E3BE2C0A3@topped-with-meat.com>
	<CAMe9rOpXRcO6a4cFEU=s1Gjzzt87zvyzuLhAWupc2pOX6az6ig@mail.gmail.com>
	<4F625570.7050003@cs.ucla.edu>
	<CAMe9rOpvnhPmpmsLedmOjjYB9SghZiov-cOUi+wrYvKaP+c9pQ@mail.gmail.com>
	<4F6267B1.3090805@cs.ucla.edu>
	<CAMe9rOrRdj_ns=rkonB2BwgmZa3KHBHTQQCv0bkH8PQ2UMXtHw@mail.gmail.com>
	<4F62F152.1040909@cs.ucla.edu>
	<CAMe9rOqz0bC6hb=f0BCGzaRHhdnqi65gFCF0h8S0Okgo7TjSsQ@mail.gmail.com>
	<4F638C5C.6080507@cs.ucla.edu>
Date: Fri, 16 Mar 2012 12:16:57 -0700
Message-ID: <CAMe9rOrxpEPjg_N7UnihFwSYTSxzGsfUCD04WsG=3xp-dYVGAw@mail.gmail.com>
Subject: Re: PATCH [3/n]: Add __snseconds_t and __SNSECONDS_T_TYPE
From: "H.J. Lu" <hjl.tools@gmail.com>
To: Paul Eggert <eggert@cs.ucla.edu>
Cc: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        GNU C Library <libc-alpha@sourceware.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 16, 2012 at 11:54 AM, Paul Eggert <eggert@cs.ucla.edu> wrote:
> On 03/16/2012 08:49 AM, H.J. Lu wrote:
>> I'd prefer to change POSIX. This isn't the only place where x32 isn't
>> 100% compatible with POSIX.
>
> If this approach is taken, the compatibility issues with tv_nsec,
> blksize_t, and suseconds_t should be documented in the glibc manual,
> in areas where programmers using the interfaces are likely to find
> out about the problem.  Could you propose a patch to do that?

I will do that once we know the full scope for POSIX issue under
x32.

> It should be possible to change POSIX at some point, once the POSIX folks
> decide that C90 compatibility is no longer an issue.  If POSIX
> conformance is not a goal of x32, then this is not an urgent matter --
> which is probably just as well, as I think they still worry about C90.
>
> In the meantime, I guess applications will just have to know not to take
> the address of a tv_nsec member.  I just now added a note
> about this in the Gnulib portability manual, where it talks about
> glitches on systems that don't conform to POSIX:
>
> http://git.savannah.gnu.org/cgit/gnulib.git/commit/?id=47834c92f8122f4ba5e6fca5199a4611425bfe69

Thanks.


-- 
H.J.
