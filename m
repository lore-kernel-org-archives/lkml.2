Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932174Ab1BXXyX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 18:54:23 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:33649 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756606Ab1BXXyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 18:54:13 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=inHTpO_ulcMA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=1Ge4xi5iaQYU0RM3k-sA:9 a=5_t2opY9LzLJQ4QbumovgOh2tAMA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] expose kvmclock upper msr set.
From: Steven Rostedt <rostedt@goodmis.org>
To: Glauber Costa <glommer@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1298591320.15736.310.camel@mothafucka.localdomain>
References: <1298483054-1665-1-git-send-email-glommer@redhat.com>
	 <20110224232456.GG888@home.goodmis.org>
	 <1298591320.15736.310.camel@mothafucka.localdomain>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 24 Feb 2011 18:54:12 -0500
Message-ID: <1298591652.6376.8.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-24 at 20:48 -0300, Glauber Costa wrote:
> On Thu, 2011-02-24 at 18:24 -0500, Steven Rostedt wrote:
> > On Wed, Feb 23, 2011 at 12:44:14PM -0500, Glauber Costa wrote:
> > > We've been supporting kvmclock MSRs in the 0x4b564d00-0x4b564dff range
> > > for a while now, but we're not exposing it yet, meaning nobody is using it.
> > > This simple patch takes care of that.
> > 
> > Is nobody using it because it was never exposed? Or because nobody ever
> > needed it, and we don't care (thus don't bother supporting it).
> > 
> The former. Our guest kernels will only rely on features that are
> exposed, meaning that if they are not, the guest kernel will never know
> it is available. 
> 

Might want to rephrase your change log, as to me it sounds like nobody
is using it because it is not needed. Adding the "Our guest..." from
your response to the change log will clear that up.

Thanks,

-- Steve


