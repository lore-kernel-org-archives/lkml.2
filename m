Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759303Ab0EMQMs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 12:12:48 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:64496 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759201Ab0EMQMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 12:12:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=eeL/MTaXPwZt8E0oT0wVmI4dZY3zXj3LofYIDSkmwIAKX19Y0sc0mpTyFkgAmSO/cF
         YO+wmAf8IRsLAslVpuaITfC39EM9gT5K6utCAF+rPaX/CmrT8bnI40VnXJCdQsRfNYcz
         qsjbVMk8yo5Q0Vn7T9kZMoE9fBgP3pqOW7uvs=
Date: Thu, 13 May 2010 18:12:44 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ian Munsie <imunsie@au1.ibm.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
       Jason Baron <jbaron@redhat.com>
Subject: Re: ftrace syscalls, PowerPC: Fixes and PowerPC raw syscall
	tracepoint implementation
Message-ID: <20100513161240.GA5377@nowhere>
References: <1273736594-19320-1-git-send-email-imunsie@au1.ibm.com> <1273766771.27703.1069.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273766771.27703.1069.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 13, 2010 at 12:06:11PM -0400, Steven Rostedt wrote:
> Frederic,
> 
> I'm fine with these patches, but since you mainly did the syscall work,
> I'll let you take them.


Sure.


 
> The patches that touch the PowerPC code needs an acked-by from Ben or
> Paul.
> 
> -- Steve



Ok,

Thanks.

