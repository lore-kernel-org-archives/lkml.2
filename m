Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755671Ab2E2U1B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 16:27:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34611 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753716Ab2E2U1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 16:27:00 -0400
Date: Tue, 29 May 2012 13:26:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>,
        LKML <linux-kernel@vger.kernel.org>,
        "markus@trippelsdorf.de" <markus@trippelsdorf.de>,
        "hughd@google.com" <hughd@google.com>,
        "kamezawa.hiroyu@jp.fujitsu.com" <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: 3.4-rc7: BUG: Bad rss-counter state mm:ffff88040b56f800 idx:1
 val:-59
Message-Id: <20120529132658.14ab9ba3.akpm@linux-foundation.org>
In-Reply-To: <4FC52F17.20709@openvz.org>
References: <4FBC1618.5010408@fold.natur.cuni.cz>
	<20120522162835.c193c8e0.akpm@linux-foundation.org>
	<20120522162946.2afcdb50.akpm@linux-foundation.org>
	<20120523172146.GA27598@redhat.com>
	<4FC52F17.20709@openvz.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 May 2012 00:18:31 +0400
Konstantin Khlebnikov <khlebnikov@openvz.org> wrote:

> Oleg Nesterov wrote:
> > On 05/22, Andrew Morton wrote:
> >>
> >> Also, I have a note here that Oleg was unhappy with the patch.  Oleg
> >> happiness is important.  Has he cheered up yet?
> >
> > Well, yes, I do not really like this patch ;) Because I think there is
> > a more simple/straightforward fix, see below. In my opinion it also
> > makes the original code simpler.
> >
> > But. Obviously this is subjective, I can't prove my patch is "better",
> > and I didn't try to test it.
> >
> > So I won't argue with Konstantin who dislikes my patch, although I
> > would like to know the reason.
> 
> I don't remember why I dislike your patch.
> For now I can only say ACK )

We'll need a changelogged signed-off patch, please Oleg.  And some evidence
that it was tested would be nice ;)

