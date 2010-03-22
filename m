Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876Ab0CVVKr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 17:10:47 -0400
Received: from alpha.arachsys.com ([91.203.57.7]:42727 "EHLO
	alpha.arachsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755428Ab0CVVKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 17:10:45 -0400
Date: Mon, 22 Mar 2010 21:10:41 +0000
From: Chris Webb <chris@arachsys.com>
To: Avi Kivity <avi@redhat.com>
Cc: Anthony Liguori <anthony@codemonkey.ws>, balbir@linux.vnet.ibm.com,
       KVM development list <kvm@vger.kernel.org>,
       Rik van Riel <riel@surriel.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RF C/T/D] Unmapped page cache control - via boot
 parameter
Message-ID: <20100322211041.GD12635@arachsys.com>
References: <4B9DE635.8030208@redhat.com>
 <20100315080726.GB18054@balbir.in.ibm.com>
 <4B9DEF81.6020802@redhat.com>
 <20100315202353.GJ3840@arachsys.com>
 <4B9EC60A.2070101@codemonkey.ws>
 <20100317151409.GY31148@arachsys.com>
 <4BA0FB83.1010502@codemonkey.ws>
 <20100317162711.GK1997@arachsys.com>
 <20100322210448.GA12635@arachsys.com>
 <4BA7DBFB.8000808@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA7DBFB.8000808@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity <avi@redhat.com> writes:

> On 03/22/2010 11:04 PM, Chris Webb wrote:
>
> >Unless I'm missing something, the risk to guest OSes in this configuration
> >should therefore be exactly the same as the risk from running on normal
> >commodity hardware with such drives and no expensive battery-backed RAM.
> 
> A host crash will destroy your data.  If  your machine is connected
> to a UPS, only a firmware crash can destroy your data.

Yes, that's a good point: in this configuration a host crash is equivalent
to a power failure rather than a OS crash in terms of data loss.

Cheers,

Chris.
