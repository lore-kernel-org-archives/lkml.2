Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756368Ab2F0T0P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 15:26:15 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58134 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755305Ab2F0T0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 15:26:13 -0400
Date: Wed, 27 Jun 2012 12:26:08 -0700
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Gavin Shan <shangw@linux.vnet.ibm.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>, hpa@linux.intel.com,
        linux-mm <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Early boot panic on machine with lots of memory
Message-ID: <20120627192608.GQ15811@google.com>
References: <20120619212618.GK32733@google.com>
 <CAE9FiQVECyRBie-kgBETmqxPaMx24kUt1W07qAqoGD4vNus5xQ@mail.gmail.com>
 <20120621201728.GB4642@google.com>
 <CAE9FiQXubmnKHjnqOxVeoJknJZFNuStCcW=1XC6jLE7eznkTmg@mail.gmail.com>
 <20120622185113.GK4642@google.com>
 <CAE9FiQVV+WOWywnanrP7nX-wai=aXmQS1Dcvt4PxJg5XWynC+Q@mail.gmail.com>
 <20120622192919.GL4642@google.com>
 <CAE9FiQVeJYwpgHjAFp5Q7PazOjeDvN_etrnej987Rc94TjXfAg@mail.gmail.com>
 <20120627181330.GN15811@google.com>
 <CAE9FiQXk4abAzuKN8xiA5p5OJaG4UMzQR_Jzx2SsKOuUnKON_A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAE9FiQXk4abAzuKN8xiA5p5OJaG4UMzQR_Jzx2SsKOuUnKON_A@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2012 at 12:22:14PM -0700, Yinghai Lu wrote:
> On Wed, Jun 27, 2012 at 11:13 AM, Tejun Heo <tj@kernel.org> wrote:
> > Hello, Yinghai.
> >
> > Sorry about the delay.  I'm in bug storm somehow. :(
> >
> > On Fri, Jun 22, 2012 at 07:14:43PM -0700, Yinghai Lu wrote:
> >> On Fri, Jun 22, 2012 at 12:29 PM, Tejun Heo <tj@kernel.org> wrote:
> >> > I wish we had a single call - say, memblock_die(), or whatever - so
> >> > that there's a clear indication that memblock usage is done, but yeah
> >> > maybe another day.  Will review the patch itself.  BTW, can't you post
> >> > patches inline anymore?  Attaching is better than corrupt but is still
> >> > a bit annoying for review.
> >>
> >> please check the three patches:
> >
> > Heh, reviewing is cumbersome this way but here are my comments.
> >
> > * "[PATCH] memblock: free allocated memblock_reserved_regions later"
> >  looks okay to me.
> 
> Good, this one should go to 3.5, right?

Yes, I think so.

Thank you!

-- 
tejun
