Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290Ab0EGLfA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 07:35:00 -0400
Received: from DMZ-MAILSEC-SCANNER-4.MIT.EDU ([18.9.25.15]:42445 "EHLO
	dmz-mailsec-scanner-4.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751878Ab0EGLe7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 07:34:59 -0400
X-Greylist: delayed 300 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 May 2010 07:34:58 EDT
X-AuditID: 1209190f-b7b20ae000003f85-99-4be3f9b5627e
Subject: Re: [PATCH 0/8] Suspend block api (version 6)
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
From: Theodore Tso <tytso@MIT.EDU>
In-Reply-To: <20100507112102.GC21498@rakim.wolfsonmicro.main>
Date: Fri, 7 May 2010 07:29:47 -0400
Cc: =?iso-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
       Brian Swetland <swetland@google.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Matthew Garrett <mjg@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Paul Walmsley <paul@pwsan.com>, magnus.damm@gmail.com,
       mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>, rebecca@android.com
Content-Transfer-Encoding: 8BIT
Message-Id: <81818215-44A2-4B74-A43F-E2644C950F5C@mit.edu>
References: <20100505185225.GA4411@srcf.ucam.org> <Pine.LNX.4.44L0.1005051511040.1885-100000@iolanthe.rowland.org> <m2oa55d774e1005051356n3610d780ra42200c1785e02bd@mail.gmail.com> <20100505234025.GB4838@opensource.wolfsonmicro.com> <l2kd6200be21005052125rc43217a2r8c65bc98e7a5d3d4@mail.gmail.com> <20100507100406.GA21498@rakim.wolfsonmicro.main> <w2kd6200be21005070357r9aad2896l355168a23bf85eae@mail.gmail.com> <20100507112102.GC21498@rakim.wolfsonmicro.main>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
X-Mailer: Apple Mail (2.1078)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On May 7, 2010, at 7:21 AM, Mark Brown wrote:
> 
> This goes back to the thing about a full system suspend being a
> sledgehammer which doesn't give enough information about what's going
> on when it's used like this.  As discussed we need a way to know that
> the connections involved are able to stay live during suspend (on a
> large proportion of systems suspend is going to mean that the relevant
> bits of the board will loose power so need to be shut down) and that
> that the intention of the user is that they should do so (this isn't
> clear in the general system, especially not if the suspend is initiated
> manually).  

This sounds like it may be something unique to your board/product.  Or am I missing something?

One of the challenges with PM in the embedded world is that everybody seems to have slightly different assumptions, and hardware that doesn't behave the same way.

More than once this discussion has wandered off into the weeds wrt to whether this patch series is ready to be merged, since there are so many drivers blocked on it....

-- Ted

