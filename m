Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349Ab0CRNDw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 09:03:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18208 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753289Ab0CRNDu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 09:03:50 -0400
Date: Thu, 18 Mar 2010 10:03:22 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Avi Kivity <avi@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       zhiteng.huang@intel.com
Subject: Re: [PATCH] Enhance perf to collect KVM guest os statistics from
	host side
Message-ID: <20100318130322.GA10215@ghostprotocols.net>
References: <1268717232.2813.36.camel@localhost> <4B9F19F7.6000309@redhat.com> <1268725724.2813.48.camel@localhost> <1268731733.2813.54.camel@localhost> <20100316094758.GH7961@elte.hu> <1268818013.2813.82.camel@localhost> <1268880310.2813.84.camel@localhost> <1268898558.2813.96.camel@localhost> <20100318080325.GA2157@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100318080325.GA2157@elte.hu>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Mar 18, 2010 at 09:03:25AM +0100, Ingo Molnar escreveu:
> 
> * Zhang, Yanmin <yanmin_zhang@linux.intel.com> wrote:
> 
> > I worked out 3 new patches against tip/master tree of Mar. 17th.
> 
> Cool! Mind sending them as a series of patches instead of attachment? That 
> makes it easier to review them. Also, the Signed-off-by lines seem to be 
> missing plus we need a per patch changelog as well.

Yeah, please, and I hadn't merged them, so the resend was the best thing to do.

- Arnaldo
