Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757982Ab1FJThV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 15:37:21 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:55951 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757750Ab1FJThS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 15:37:18 -0400
Date: Fri, 10 Jun 2011 12:37:13 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Kyungmin Park <kmpark@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ankita Garg <ankita@in.ibm.com>, linux-arm-kernel@lists.infradead.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-pm@lists.linux-foundation.org, svaidy@linux.vnet.ibm.com,
        thomas.abraham@linaro.org
Subject: Re: [PATCH 00/10] mm: Linux VM Infrastructure to support Memory
 Power Management
Message-ID: <20110610193713.GJ2230@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110610151121.GA2230@linux.vnet.ibm.com>
 <20110610155954.GA25774@srcf.ucam.org>
 <20110610165529.GC2230@linux.vnet.ibm.com>
 <20110610170535.GC25774@srcf.ucam.org>
 <20110610171939.GE2230@linux.vnet.ibm.com>
 <20110610172307.GA27630@srcf.ucam.org>
 <20110610175248.GF2230@linux.vnet.ibm.com>
 <20110610180807.GB28500@srcf.ucam.org>
 <20110610184738.GG2230@linux.vnet.ibm.com>
 <20110610192329.GA30496@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110610192329.GA30496@srcf.ucam.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 10, 2011 at 08:23:29PM +0100, Matthew Garrett wrote:
> On Fri, Jun 10, 2011 at 11:47:38AM -0700, Paul E. McKenney wrote:
> 
> > And if I understand you correctly, then the patches that Ankita posted
> > should help your self-refresh case, along with the originally intended
> > the power-down case and special-purpose use of memory case.
> 
> Yeah, I'd hope so once we actually have capable hardware.

Cool!!!

So Ankita's patchset might be useful to you at some point, then.

Does it look like a reasonable implementation?

							Thanx, Paul
