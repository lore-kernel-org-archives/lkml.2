Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030696Ab2GLQOF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 12:14:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13757 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030404Ab2GLQOD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 12:14:03 -0400
Date: Thu, 12 Jul 2012 19:13:59 +0300
From: Gleb Natapov <gleb@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: perf with precise attribute kills all KVM based VMs
Message-ID: <20120712161359.GJ7298@redhat.com>
References: <4FFAEFF1.9000706@redhat.com>
 <1341845999.3462.86.camel@twins>
 <4FFCBD00.1030109@gmail.com>
 <20120711071006.GF23898@redhat.com>
 <1342000187.3462.134.camel@twins>
 <20120711095337.GJ23898@redhat.com>
 <4FFE4E8D.90606@gmail.com>
 <20120712042923.GG7298@redhat.com>
 <4FFEEB55.5070009@gmail.com>
 <20120712160634.GI7298@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120712160634.GI7298@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2012 at 07:06:35PM +0300, Gleb Natapov wrote:
> > 
> > So, is the idea of your patch to not enable the PEBS in guest mode?
> > 
> Yes, the idea of my patch is to disable PEBS and the guest entry.
> 
BTW what is you host cpu? My patch works only for those that have global
control register to disable PMU events, but that should cover most of
moder cpus.

--
			Gleb.
