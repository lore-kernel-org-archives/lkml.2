Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755591Ab1IKA6M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Sep 2011 20:58:12 -0400
Received: from mail-vw0-f43.google.com ([209.85.212.43]:40005 "EHLO
	mail-vw0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398Ab1IKA6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Sep 2011 20:58:10 -0400
Date: Sun, 11 Sep 2011 09:58:04 +0900
From: Tejun Heo <tj@kernel.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Why I want PTRACE_O_TRACESTOP option
Message-ID: <20110911005804.GF29319@htj.dyndns.org>
References: <1315500802.18043.45.camel@dhcp-25-63.brq.redhat.com>
 <20110909001853.GA29319@htj.dyndns.org>
 <201109090754.50272.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201109090754.50272.vda.linux@googlemail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Denys.

On Fri, Sep 09, 2011 at 07:54:50AM +0200, Denys Vlasenko wrote:
> My point is that previously, ptrace behavior was modified by setting
> options. Why don't we use this mechanism? Why we invent a different
> wheel? Ptrace is ugly as-is, why complicate it even further?
> 
> The argument was that SETOPTIONS wasn't suitable for modifying
> attach behavior, but this is fixed by "set options on SEIZE"
> patch. I don't see why we can't use options mechanist to affect
> group-stop behavior now.

The argument was that there are other more difficult issues and the
added benefit - superficial consistency - doesn't justify the
necessary complexity, and it was repeated multiple times.

Thanks.

-- 
tejun
