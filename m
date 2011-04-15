Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757147Ab1DOVIZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 17:08:25 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:48776 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757103Ab1DOVIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 17:08:24 -0400
Date: Fri, 15 Apr 2011 14:08:19 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, ebiederm@xmission.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Subject: Re: [PATCH] powerpc: Fix kexec-related UP build error
Message-ID: <20110415210819.GE2283@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110415202916.GA6758@linux.vnet.ibm.com>
 <20110415210051.GA31245@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110415210051.GA31245@us.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 15, 2011 at 02:00:51PM -0700, Nishanth Aravamudan wrote:
> Hi Paul,
> 
> On 15.04.2011 [13:29:16 -0700], Paul E. McKenney wrote:
> > Hello!
> > 
> > The following patch fixes a UP build problem for kexec() on powerpc.
> > When the crash_kexec_wait_realmode() function was added, it was
> > placed in only two of the three required locations.
> 
> I believe the fix has already been posted as
> 
> http://lists.ozlabs.org/pipermail/linuxppc-dev/2011-April/089559.html

So it has!  Thank you for the pointer.

							Thanx, Paul
