Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003Ab1IJXnN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Sep 2011 19:43:13 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:47332 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862Ab1IJXnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Sep 2011 19:43:12 -0400
Date: Sun, 11 Sep 2011 08:43:06 +0900
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>,
        Denys Vlasenko <dvlasenk@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Why I want PTRACE_O_TRACESTOP option
Message-ID: <20110910234306.GE29319@htj.dyndns.org>
References: <1315500802.18043.45.camel@dhcp-25-63.brq.redhat.com>
 <20110909001853.GA29319@htj.dyndns.org>
 <201109090745.35040.vda.linux@googlemail.com>
 <20110909160048.GA23271@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110909160048.GA23271@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 09, 2011 at 06:00:48PM +0200, Oleg Nesterov wrote:
> On 09/09, Denys Vlasenko wrote:
> >
> > How about changing PTRACE_EVENT_STOP value to, say, 255 then,
> > in order to move it away from (option,event) area?
> 
> Probably makes sense.

Yeap, no objection from me.

Thanks.

-- 
tejun
