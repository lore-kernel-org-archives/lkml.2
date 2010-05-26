Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934381Ab0EZWoN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 18:44:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44953 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755871Ab0EZWoL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 18:44:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 2/8] PM: suspend_block: Add driver to access suspend blockers from user-space
Date: Thu, 27 May 2010 00:45:15 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-tst; KDE/4.3.5; x86_64; ; )
Cc: Peter Zijlstra <peterz@infradead.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
       Jim Collar <jim.collar@eqware.net>,
       "Greg Kroah-Hartman" <gregkh@suse.de>, Avi Kivity <avi@redhat.com>,
       Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
       Magnus Damm <damm@igel.co.jp>, Nigel Cunningham <nigel@tuxonice.net>,
       linux-doc@vger.kernel.org
References: <1274482015-30899-1-git-send-email-arve@android.com> <201005262357.28933.rjw@sisk.pl> <20100526231448.41c5be7f@lxorguk.ukuu.org.uk>
In-Reply-To: <20100526231448.41c5be7f@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005270045.15540.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 May 2010, Alan Cox wrote:
> > This whole thing is related to the statistics part, which Arve says is
> > essential to him.  He wants to collect statistics for each suspend blocker
> > activated and deactivated so that he can tell who's causing problems by
> > blocking suspend too often.  The name also is a part of this.
> 
> If he wants to collect stats about misbehaving code then presumably he
> needs reliable stats. Arbitary user set names are not reliable and
> judging by app vendor behaviour in the proprietary space with other such
> examples they will actively name their blockers in a manner specifically
> intended to hide the cause so as to 'reduce support costs'.
> 
> Its a waste of memory (especially if I create a million of them with a
> long name for fun).

Well, I won't argue with that. :-)

> It's all an economic system, proprietary app vendors are in it to make
> money, some will therefore game the system and the rest will be forced to
> follow to keep their playing field fair.

Good point.

Rafael
