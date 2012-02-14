Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761306Ab2BNWHH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 17:07:07 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:36631 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761294Ab2BNWHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 17:07:01 -0500
Message-ID: <1329257161.2340.1.camel@work-vm>
Subject: Re: [RFC] [PATCH v5 0/3] fadvise: support POSIX_FADV_NOREUSE
From: John Stultz <john.stultz@linaro.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrea Righi <andrea@betterlinux.com>, Minchan Kim <minchan.kim@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Johannes Weiner <jweiner@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Hugh Dickins <hughd@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Shaohua Li <shaohua.li@intel.com>,
        =?ISO-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>,
        Jerry James <jamesjer@betterlinux.com>,
        Julius Plenz <julius@plenz.com>, linux-mm <linux-mm@kvack.org>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Date: Tue, 14 Feb 2012 14:06:01 -0800
In-Reply-To: <20120214133337.9de7835b.akpm@linux-foundation.org>
References: <1329006098-5454-1-git-send-email-andrea@betterlinux.com>
	 <20120214133337.9de7835b.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12021422-3352-0000-0000-000002A0B82D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-02-14 at 13:33 -0800, Andrew Morton wrote:
> On Sun, 12 Feb 2012 01:21:35 +0100
> Andrea Righi <andrea@betterlinux.com> wrote:
> 
> > The new proposal is to implement POSIX_FADV_NOREUSE as a way to perform a real
> > drop-behind policy where applications can mark certain intervals of a file as
> > FADV_NOREUSE before accessing the data.
> 
> I think you and John need to talk to each other, please.  The amount of
> duplication here is extraordinary.

Yea. Clearly there is much we can share. I'm still catching up from a
conference last week, so I've not had a chance to really look at this
yet, but its on my queue for this week.

thanks
-john


