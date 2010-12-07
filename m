Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751444Ab0LGFSJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 00:18:09 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:39008 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698Ab0LGFSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 00:18:08 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=up3NAqt5ug8A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=qWWOT8dG2TpXy85RPvcA:9 a=Jd59gGdnZYqIjnIicGhtMS_6rmEA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 4/6] ftrace syscalls: Allow arch specific syscall
 symbol matching
From: Steven Rostedt <rostedt@goodmis.org>
To: Ian Munsie <imunsie@au1.ibm.com>
Cc: Mike Frysinger <vapier@gentoo.org>,
        Avantika Mathur <mathur@linux.vnet.ibm.com>,
        Jason Baron <jbaron@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-doc <linux-doc@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1291698267-sup-2037@au1.ibm.com>
References: <1291696151-4336-1-git-send-email-imunsie@au1.ibm.com>
	 <1291696151-4336-5-git-send-email-imunsie@au1.ibm.com>
	 <AANLkTik7O=xVP2WuD+AV-oQqg9heT4fVbEa65W+BRq11@mail.gmail.com>
	 <1291698267-sup-2037@au1.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 07 Dec 2010 00:18:04 -0500
Message-ID: <1291699084.16223.138.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-12-07 at 16:06 +1100, Ian Munsie wrote:
> Excerpts from Mike Frysinger's message of Tue Dec 07 15:56:49 +1100 2010:
> > useless set of parenthesis, and this overhead sucks.  weak +
> > additional function call just for a strcmp for most people ?  why not
> > make it into a define in the header:
> > #ifndef arch_syscall_match_sym_name
> > #define arch_syscall_match_sym_name(sym, name) !strcmp(sym + 3, name + 3)

Make it a static inline function please.

-- Steve

> > #endif
> > -mike
> 
> No problem, will change it.
> 
> Cheers,
> -Ian


