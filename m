Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756374Ab0CXQpF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 12:45:05 -0400
Received: from 8bytes.org ([88.198.83.132]:52045 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753607Ab0CXQpD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 12:45:03 -0400
Date: Wed, 24 Mar 2010 17:45:00 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Avi Kivity <avi@redhat.com>
Cc: "Daniel P. Berrange" <berrange@redhat.com>,
       Anthony Liguori <anthony@codemonkey.ws>, Ingo Molnar <mingo@elte.hu>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       ziteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>,
       Gregory Haskins <ghaskins@novell.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
	project
Message-ID: <20100324164500.GN14800@8bytes.org>
References: <20100324150137.GE14800@8bytes.org> <20100324152653.GA12225@redhat.com> <20100324153746.GF14800@8bytes.org> <4BAA3323.9000405@redhat.com> <20100324155041.GH14800@8bytes.org> <4BAA3556.2040802@redhat.com> <20100324161711.GJ14800@8bytes.org> <4BAA3BD6.8030401@redhat.com> <20100324163119.GL14800@8bytes.org> <4BAA3EB3.2070101@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BAA3EB3.2070101@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 24, 2010 at 06:32:51PM +0200, Avi Kivity wrote:
> On 03/24/2010 06:31 PM, Joerg Roedel wrote:

> That's just what I want to do.  Leave it in userspace and then they can  
> deal with it without telling us about it.

They can't do that with a directory in /proc?

