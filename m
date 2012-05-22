Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281Ab2EVRjJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 13:39:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46974 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751747Ab2EVRjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 13:39:04 -0400
Date: Tue, 22 May 2012 13:38:49 -0400
From: Dave Jones <davej@redhat.com>
To: Christoph Lameter <cl@linux.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Stephen Wilson <wilsons@start.ca>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 3.4-rc7 numa_policy slab poison.
Message-ID: <20120522173849.GA13590@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Christoph Lameter <cl@linux.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
	KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
	Stephen Wilson <wilsons@start.ca>, Mel Gorman <mgorman@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>
References: <20120521154709.GA8697@redhat.com>
 <CA+55aFyqMJ1X08kQwJ7snkYo6MxfVKqFJx7LXBkP_ug4LTCZ=Q@mail.gmail.com>
 <20120521200118.GA12123@redhat.com>
 <alpine.DEB.2.00.1205211510480.10940@router.home>
 <20120521202904.GB12123@redhat.com>
 <alpine.DEB.2.00.1205211535050.10940@router.home>
 <20120521203838.GD12123@redhat.com>
 <alpine.DEB.2.00.1205211544340.10940@router.home>
 <20120521210959.GF12123@redhat.com>
 <alpine.DEB.2.00.1205221226330.21828@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1205221226330.21828@router.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2012 at 12:27:14PM -0500, Christoph Lameter wrote:
 > On Mon, 21 May 2012, Dave Jones wrote:
 > 
 > > ok, added a --nocolors option now. Re-pull.
 > > I'll look at the dependancy problem next. Thanks for the feedback.
 > 
 > --monochrome you mean?

yes, sorry. I changed it shortly after sending that email.
I was having serious conniptions over the use of color/colour.

 > -m works for a part of the output but then the color hits again.

Fixed. I forgot to change the getopt string

	Dave
