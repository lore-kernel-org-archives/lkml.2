Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751992Ab1B0J3R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 04:29:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40275 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751923Ab1B0J3I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 04:29:08 -0500
Message-ID: <4D6A195D.7000203@redhat.com>
Date: Sun, 27 Feb 2011 11:29:01 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: Steven Rostedt <rostedt@goodmis.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] expose kvmclock upper msr set.
References: <1298483054-1665-1-git-send-email-glommer@redhat.com>	 <20110224232456.GG888@home.goodmis.org>	 <1298591320.15736.310.camel@mothafucka.localdomain>	 <1298591652.6376.8.camel@gandalf.stny.rr.com> <1298639488.15736.313.camel@mothafucka.localdomain>
In-Reply-To: <1298639488.15736.313.camel@mothafucka.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25/2011 03:11 PM, Glauber Costa wrote:
> On Thu, 2011-02-24 at 18:54 -0500, Steven Rostedt wrote:
> >  On Thu, 2011-02-24 at 20:48 -0300, Glauber Costa wrote:
> >  >  On Thu, 2011-02-24 at 18:24 -0500, Steven Rostedt wrote:
> >  >  >  On Wed, Feb 23, 2011 at 12:44:14PM -0500, Glauber Costa wrote:
> >  >  >  >  We've been supporting kvmclock MSRs in the 0x4b564d00-0x4b564dff range
> >  >  >  >  for a while now, but we're not exposing it yet, meaning nobody is using it.
> >  >  >  >  This simple patch takes care of that.
> >  >  >
> >  >  >  Is nobody using it because it was never exposed? Or because nobody ever
> >  >  >  needed it, and we don't care (thus don't bother supporting it).
> >  >  >
> >  >  The former. Our guest kernels will only rely on features that are
> >  >  exposed, meaning that if they are not, the guest kernel will never know
> >  >  it is available.
> >  >
> >
> >  Might want to rephrase your change log, as to me it sounds like nobody
> >  is using it because it is not needed. Adding the "Our guest..." from
> >  your response to the change log will clear that up.
> >
> >  Thanks,
> I can do that, sure.
>
> OTOH, I know avi changed changelogs for clarity a couple of times
> before, so if there is no code change needed, maybe he think it is
> easier to rephrase it before picking it up.
>
> Avi?
>

If that's the only change, no problem.

-- 
error compiling committee.c: too many arguments to function

