Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633Ab2GVUm4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 16:42:56 -0400
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:59888 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752001Ab2GVUmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 16:42:54 -0400
Subject: Re: [PATCH 1/2] kthread_worker: reorganize to prepare for
 flush_kthread_work() reimplementation
From: Andy Walls <awalls@md.metrocast.net>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
        ivtv-devel@ivtvdriver.org, linux-media@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 22 Jul 2012 16:42:12 -0400
In-Reply-To: <20120722164607.GB5144@dhcp-172-17-108-109.mtv.corp.google.com>
References: <20120719211510.GA32763@google.com>
	 <20120719211541.GB32763@google.com>
	 <1342890808.2504.3.camel@palomino.walls.org>
	 <20120722164607.GB5144@dhcp-172-17-108-109.mtv.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1342989735.2487.15.camel@palomino.walls.org>
Mime-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.260,0.0.0000
 definitions=2012-07-22_05:2012-07-20,2012-07-22,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 suspectscore=0
 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=6.0.2-1203120001 definitions=main-1207220255
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-07-22 at 09:46 -0700, Tejun Heo wrote:
> Hello,
> 
> On Sat, Jul 21, 2012 at 01:13:27PM -0400, Andy Walls wrote:
> > > +/* insert @work before @pos in @worker */
> > 
> > Hi Tejun,
> > 
> > Would a comment that the caller should be holding worker->lock be useful
> > here?  Anyway, comment or not:
> > 
> > Acked-by: Andy Walls <awall@md.metrocast.net>
> 
> Will add lockdep_assert_held().  Thanks!
> 

Great!  Thank you.

Regards,
Andy 

