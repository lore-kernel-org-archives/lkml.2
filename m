Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758633Ab2EUUrV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 16:47:21 -0400
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:41490 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754046Ab2EUUrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 16:47:20 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: oefWbKkVM1nVa8HU23.3V1fFRZ65iKGZwFg48ksDwGM5vjI
 mP1YiclGuFnQUE19Xi5sRYOfoh37rIb8IFt5zAvfmJ0qxH39ecsPGH.eL8h4
 qiu3Efg2BdGa1Nl0MmEPLJu5IuB7dR8EZ2cu5YcKh40TzhCByP5eGGQlbUYk
 vKrOAERLZEvcuSTfqcPtJoz2uRW_SfmTiIoCgH1ukB4XcpJwpp1U5fCe7Ahh
 GtrX5d40f.sfIeNFPbANH23npa6EILWMrx5A0zSA7ndKBrjxfef2EZJLHU6f
 0FpPOtKjOfDc8PRZq9Oz7Eu7Zm00eYunh5dIdf7V8ekyq3r9oOHcOj.Tz1T1
 JcJsvZWVG.io0XL1EHhstsvq3oUwKmr5Hol_S9vGcLleO3LY7RAB4M46TmZ1
 JCPcA8ISIyufbXD4fufSjkZ8LJpwC.3ASUZMe
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 21 May 2012 15:47:16 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Dave Jones <davej@redhat.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Stephen Wilson <wilsons@start.ca>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 3.4-rc7 numa_policy slab poison.
In-Reply-To: <20120521203838.GD12123@redhat.com>
Message-ID: <alpine.DEB.2.00.1205211544340.10940@router.home>
References: <20120517213120.GA12329@redhat.com> <20120518185851.GA5728@redhat.com> <20120521154709.GA8697@redhat.com> <CA+55aFyqMJ1X08kQwJ7snkYo6MxfVKqFJx7LXBkP_ug4LTCZ=Q@mail.gmail.com> <20120521200118.GA12123@redhat.com> <alpine.DEB.2.00.1205211510480.10940@router.home>
 <20120521202904.GB12123@redhat.com> <alpine.DEB.2.00.1205211535050.10940@router.home> <20120521203838.GD12123@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 May 2012, Dave Jones wrote:

> On Mon, May 21, 2012 at 03:36:39PM -0500, Christoph Lameter wrote:
>  > On Mon, 21 May 2012, Dave Jones wrote:
>  >
>  > > It does create log files in the current dir with the parameters used.
>  > > You should be able to grep for the pid that caused the actual oops.
>  >
>  > Ugghh. It screws up the colors on my screeen. Lightgrey on white. Is there
>  > any way to get these horrible escape sequences cleared out? If I use
>  > "less" to view the output then there are just the escape sequences
>  > visible.
>
> Define them to nothing in trinity.h

Dependencies are not correctly set. I had to do a "make clean" to get a
rebuild done.

Cannot set them to "" since the compiler then fails the compile. Set to "
" instead but that looks horrible too.

It still wont trigger with

	./trinity -c mbind

