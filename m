Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641Ab1BXXst (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 18:48:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63325 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932141Ab1BXXsp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 18:48:45 -0500
Subject: Re: [PATCH] expose kvmclock upper msr set.
From: Glauber Costa <glommer@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20110224232456.GG888@home.goodmis.org>
References: <1298483054-1665-1-git-send-email-glommer@redhat.com>
	 <20110224232456.GG888@home.goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat
Date: Thu, 24 Feb 2011 20:48:40 -0300
Message-ID: <1298591320.15736.310.camel@mothafucka.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-24 at 18:24 -0500, Steven Rostedt wrote:
> On Wed, Feb 23, 2011 at 12:44:14PM -0500, Glauber Costa wrote:
> > We've been supporting kvmclock MSRs in the 0x4b564d00-0x4b564dff range
> > for a while now, but we're not exposing it yet, meaning nobody is using it.
> > This simple patch takes care of that.
> 
> Is nobody using it because it was never exposed? Or because nobody ever
> needed it, and we don't care (thus don't bother supporting it).
> 
The former. Our guest kernels will only rely on features that are
exposed, meaning that if they are not, the guest kernel will never know
it is available. 


