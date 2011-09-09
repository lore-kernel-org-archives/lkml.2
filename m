Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932740Ab1IIFpm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 01:45:42 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49085 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755783Ab1IIFpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 01:45:39 -0400
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Tejun Heo <tj@kernel.org>
Subject: Re: Why I want PTRACE_O_TRACESTOP option
Date: Fri, 9 Sep 2011 07:45:35 +0200
User-Agent: KMail/1.8.2
Cc: Denys Vlasenko <dvlasenk@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org
References: <1315500802.18043.45.camel@dhcp-25-63.brq.redhat.com> <20110909001853.GA29319@htj.dyndns.org>
In-Reply-To: <20110909001853.GA29319@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201109090745.35040.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 September 2011 02:18, Tejun Heo wrote:
> Hello, Denys.
> 
> On Thu, Sep 08, 2011 at 06:50:01PM +0200, Denys Vlasenko wrote:
> > Consider what will happen when a next ptrace fix will require
> > a way to change ptrace API at runtime. A new option will likely
> > be introduced, say, PTRACE_O_TRACEPONY, with next available
> > bit position 7, and perhaps some new event will be generated,
> > PTRACE_EVENT_PONY, with value.... yes, it can't be 7,
> > PTRACE_EVENT_STOP took it. So it will probably be 8.
> 
> Then, just give it the next matching number.
> 
> If options naturally happen to match the events, that's a nice
> coincidence.  If the real life requirement deviates from the beautiful
> one-to-one mapping, then, so be it.  No, the magical contiguous one to
> one mapping isn't the most important design concern.
> 
> To me, the rationale presented here almost argues against
> PTRACE_O_TRACESTOP.  :(

How about changing PTRACE_EVENT_STOP value to, say, 255 then,
in order to move it away from (option,event) area?

-- 
vda
