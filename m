Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757840Ab2EVR7h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 13:59:37 -0400
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:44093 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755444Ab2EVR7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 13:59:36 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: EzUZiXIVM1mhWUT68A2PQxko.yVk3huUnKTvxZjFg7KgJ5q
 ss58cTKNPUnVRzAiMw29kfbaZ_SExKht6Vy.F47dNVYs7qZx0RlCqdYNcjG6
 apfXZVtbUVEn2xhhjuipCUr7eOriEuXNw5AVw2xUl6fN2UJx64KSBuriKK.K
 xLwH6zYZoscI0aFficrqiN6kmJzQAGGnlFy4YbuKcb95FhYemBi1n2HoZiYz
 5oE62b1R6gdobPrxLNAA8WA7dkoj1U8mcTMjD7cTXxAVLsYPgy34Txy2sb_r
 tcB5fbPS3GpXXQuTnSQnC9fKjWt_5.mRcBEQBYKMS1KLY0XwGEN.WuywVY5D
 Una7atcGyT4JkxkckyHW53RwABxxLPZamBa7_Sc1tALvQ5j51_AQdK0O02ZH
 R
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 22 May 2012 12:59:32 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Dave Jones <davej@redhat.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Stephen Wilson <wilsons@start.ca>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 3.4-rc7 numa_policy slab poison.
In-Reply-To: <20120522173849.GA13590@redhat.com>
Message-ID: <alpine.DEB.2.00.1205221257520.21828@router.home>
References: <20120521154709.GA8697@redhat.com> <CA+55aFyqMJ1X08kQwJ7snkYo6MxfVKqFJx7LXBkP_ug4LTCZ=Q@mail.gmail.com> <20120521200118.GA12123@redhat.com> <alpine.DEB.2.00.1205211510480.10940@router.home> <20120521202904.GB12123@redhat.com>
 <alpine.DEB.2.00.1205211535050.10940@router.home> <20120521203838.GD12123@redhat.com> <alpine.DEB.2.00.1205211544340.10940@router.home> <20120521210959.GF12123@redhat.com> <alpine.DEB.2.00.1205221226330.21828@router.home>
 <20120522173849.GA13590@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 May 2012, Dave Jones wrote:

> On Tue, May 22, 2012 at 12:27:14PM -0500, Christoph Lameter wrote:
>  > On Mon, 21 May 2012, Dave Jones wrote:
>  >
>  > > ok, added a --nocolors option now. Re-pull.
>  > > I'll look at the dependancy problem next. Thanks for the feedback.
>  >
>  > --monochrome you mean?
>
> yes, sorry. I changed it shortly after sending that email.
> I was having serious conniptions over the use of color/colour.
>
>  > -m works for a part of the output but then the color hits again.
>
> Fixed. I forgot to change the getopt string

Ok got momochrome output running but it does not trigger when outputting
to the console.

When I switch console output off I get an immediate oops and the system
hangs (slub resiliency/debug off).


