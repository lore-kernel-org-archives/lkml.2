Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751Ab2GRPbd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 11:31:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11322 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751743Ab2GRPb3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 11:31:29 -0400
Date: Wed, 18 Jul 2012 11:31:23 -0400
From: Dave Jones <davej@redhat.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Darren Hart <dvhart@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: potential NULL dereference in futex_wait_requeue_pi()
Message-ID: <20120718153123.GA24408@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Darren Hart <dvhart@linux.intel.com>, linux-kernel@vger.kernel.org
References: <20120718142514.GA18850@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120718142514.GA18850@elgon.mountain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2012 at 05:25:14PM +0300, Dan Carpenter wrote:
 > Hi Darren,
 > 
 > The patch 52400ba94675: "futex: add requeue_pi functionality" from
 > Apr 3, 2009, leads to the following warning:
 > kernel/futex.c:2373 futex_wait_requeue_pi()
 > 	 error: potential NULL dereference 'pi_mutex'.

This sounds like the oops I saw that I reported at https://lkml.org/lkml/2012/7/13/328

	Dave
