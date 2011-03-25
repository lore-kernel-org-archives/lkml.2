Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202Ab1CYTbi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 15:31:38 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36965 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443Ab1CYTbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 15:31:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=GuQeC3z+HLCs/Q+YsqO2tluQLkveHk8BaOz/ArUlErYXaEGkYqxFD08zmTdC6gmUGU
         3Lnk+o4PPP8eIJJndXDxz/9rF/u3IXLWaMQ9jOMKCYO3cTx0HRlhUhr9MQgv2rfRtjGa
         u+JjWef31aBcp3jNU+O9PW3D4lxeKKnLCHT0g=
Date: Fri, 25 Mar 2011 21:31:28 +0200
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, dvhart@linux.intel.com,
        peterz@infradead.org, akpm@linux-foundation.org, srostedt@redhat.com,
        tglx@linutronix.de, laijs@cn.fujitsu.com, mingo@elte.hu,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/urgent] WARN_ON_SMP(): Allow use in if() statements on
 UP
Message-ID: <20110325193128.GA5839@p183.telecom.by>
References: <20110317192208.444147791@goodmis.org>
 <tip-2092e6be82ec71ecbf5a8ceeef004bbcbdb78812@git.kernel.org>
 <AANLkTikfq9bz_cKdvq9ab+KS218Q7uVvoNdJeMe_-RUg@mail.gmail.com>
 <1301076981.14261.197.camel@gandalf.stny.rr.com>
 <1301077163.14261.199.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301077163.14261.199.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25, 2011 at 02:19:23PM -0400, Steven Rostedt wrote:
> On Fri, 2011-03-25 at 14:16 -0400, Steven Rostedt wrote:
> 
> > Also, a quick test shows that
> > 
> > 	0;
> > 
> > gives the warning:
> > 
> > 	"warning: statement with no effect"
> 
> Would you like me to add a comment that states:
> 
> 	/*
> 	 * Use ({0;}) as just "0" will cause gcc to output:
> 	 *   warning: statement with no effect
> 	 */

Try ((void)0)
