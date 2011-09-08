Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757599Ab1IHA2E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 20:28:04 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64920 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756557Ab1IHA2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 20:28:01 -0400
Date: Thu, 8 Sep 2011 09:27:52 +0900
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>,
        Denys Vlasenko <dvlasenk@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make PTRACE_SEIZE set ptrace options specified in data
 parameter
Message-ID: <20110908002752.GB3987@mtj.dyndns.org>
References: <201109070647.40850.vda.linux@googlemail.com>
 <20110907170212.GB5176@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110907170212.GB5176@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Sep 07, 2011 at 07:02:12PM +0200, Oleg Nesterov wrote:
> On 09/07, Denys Vlasenko wrote:
> > Make PTRACE_SEIZE set ptrace options specified in data parameter
> 
> Personally I think this makes sense, and in fact I suggested this
> from the very beginning.
> 
> Oh. But since we are goin to establish the API rules, this should
> be discussed.
> 
> IIRC, Tejun disliked this idea. Tejun?

I wasn't sure whether it was necessary but TRACEEXEC needs to be set
atomically and it probably is better to expose flag setting than
implicitly setting it on SEIZE, so no objection from me.

Will comment on the newer version of the patch.

Thanks.

-- 
tejun
