Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759987Ab2EVR1U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 13:27:20 -0400
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:29952 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753625Ab2EVR1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 13:27:18 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: d.KVMSEVM1k1HwDYlu8mne.08ovWwP3iE9m5Z52qTSLwPz3
 U1e1jT.4R7FVrKHuxuuO9c5lwwETf_3UkEv.2hnFWVwl7Bk.FT4haw0e0gIf
 WzB9fnu1_1xmFjcfjdJfORk.YD8up6ejVn115GuCgtTsuOMLrOZR6hG9ZyAE
 Wk.hIP6yXH7g.TzNcCdplmX7USznSEXw2DDCw8.Vmwf86ZUkIBo_C5pHrcZ9
 R_FpOE_oFiD5tudmDICZhRJ8TObLmc1Wsk9G3TDt6dIExnG5bGTArRzbTNDR
 NPRKegK3W1QG.0broEKQ7dgT7P1yptloyqCRNt1EOr9bV95sVTrBY.FB4yPF
 37zv6DuCX3Zd.O40SUQRypokZxMDRoy6NHoVWmw39xx8LTuhcp7pxNY65rK.
 L
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 22 May 2012 12:27:14 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Dave Jones <davej@redhat.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Stephen Wilson <wilsons@start.ca>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 3.4-rc7 numa_policy slab poison.
In-Reply-To: <20120521210959.GF12123@redhat.com>
Message-ID: <alpine.DEB.2.00.1205221226330.21828@router.home>
References: <20120517213120.GA12329@redhat.com> <20120518185851.GA5728@redhat.com> <20120521154709.GA8697@redhat.com> <CA+55aFyqMJ1X08kQwJ7snkYo6MxfVKqFJx7LXBkP_ug4LTCZ=Q@mail.gmail.com> <20120521200118.GA12123@redhat.com> <alpine.DEB.2.00.1205211510480.10940@router.home>
 <20120521202904.GB12123@redhat.com> <alpine.DEB.2.00.1205211535050.10940@router.home> <20120521203838.GD12123@redhat.com> <alpine.DEB.2.00.1205211544340.10940@router.home> <20120521210959.GF12123@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 May 2012, Dave Jones wrote:

> ok, added a --nocolors option now. Re-pull.
> I'll look at the dependancy problem next. Thanks for the feedback.

--monochrome you mean?

-m works for a part of the output but then the color hits again.

