Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588Ab0FQGEe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 02:04:34 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:56049 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917Ab0FQGEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 02:04:33 -0400
Date: Thu, 17 Jun 2010 11:34:28 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Avi Kivity <avi@redhat.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>, kvm <kvm@vger.kernel.org>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC/T/D][PATCH 2/2] Linux/Guest cooperative unmapped page cache
 control
Message-ID: <20100617060428.GH4306@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20100614125010.GU5191@balbir.in.ibm.com>
 <4C162846.7030303@redhat.com>
 <1276529596.6437.7216.camel@nimitz>
 <4C164E63.2020204@redhat.com>
 <1276530932.6437.7259.camel@nimitz>
 <4C1659F8.3090300@redhat.com>
 <1276538293.6437.7528.camel@nimitz>
 <4C1726C4.8050300@redhat.com>
 <1276613249.6437.11516.camel@nimitz>
 <4C18B7D6.5070300@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4C18B7D6.5070300@redhat.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Avi Kivity <avi@redhat.com> [2010-06-16 14:39:02]:

> >We're talking about an environment which we're always trying to
> >optimize.  Imagine that we're always trying to consolidate guests on to
> >smaller numbers of hosts.  We're effectively in a state where we
> >_always_ want new guests.
> 
> If this came at no cost to the guests, you'd be right.  But at some
> point guest performance will be hit by this, so the advantage gained
> from freeing memory will be balanced by the disadvantage.
> 
> Also, memory is not the only resource.  At some point you become cpu
> bound; at that point freeing memory doesn't help and in fact may
> increase your cpu load.
>

We'll probably need control over other resources as well, but IMHO
memory is the most precious because it is non-renewable. 

-- 
	Three Cheers,
	Balbir
