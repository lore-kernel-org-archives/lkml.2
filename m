Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195Ab1BHQyw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 11:54:52 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:60186 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754689Ab1BHQyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 11:54:50 -0500
X-Authority-Analysis: v=1.1 cv=dquaJDitHqzHCdqWSoZ6IgapSuTzW/4TaRYx9N9k4W8= c=1 sm=0 a=q1gOGqRNiosA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=eLvBjSu_9cH7wookToIA:9 a=ir91xW_BGd7ynhMXhKYDzU-pyWUA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 5/6] ftrace, powerpc: Implement raw syscall tracepoints
 on PowerPC
From: Steven Rostedt <rostedt@goodmis.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Ian Munsie <imunsie@au1.ibm.com>, linux-kernel@vger.kernel.org,
        Andreas Dilger <adilger@dilger.ca>,
        Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Jason Baron <jbaron@redhat.com>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Alexander Graf <agraf@suse.de>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Scott Wood <scottwood@freescale.com>, Nathan Lynch <ntl@pobox.com>,
        Avantika Mathur <mathur@linux.vnet.ibm.com>,
        David Gibson <dwg@au1.ibm.com>, Andreas Schwab <schwab@linux-m68k.org>,
        Namhyung Kim <namhyung@gmail.com>
In-Reply-To: <1297159672.14982.205.camel@pasglop>
References: <1296703645-18718-1-git-send-email-imunsie@au1.ibm.com>
	 <1296703645-18718-6-git-send-email-imunsie@au1.ibm.com>
	 <1297131028.23343.7.camel@gandalf.stny.rr.com>
	 <1297159672.14982.205.camel@pasglop>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 08 Feb 2011 11:54:46 -0500
Message-ID: <1297184086.23343.10.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-08 at 21:07 +1100, Benjamin Herrenschmidt wrote:
> On Mon, 2011-02-07 at 21:10 -0500, Steven Rostedt wrote:
> > Ben,
> > 
> > How do you want to work this? Do you want to ack it and I take this
> > patch with the others through the tracing tree, or do you want to wait
> > till the tracing tree gets updated into mainline and then pull this in
> > though the ppc tree. As this touches a bit of the ppc side.
> 
> I was waiting to see what you were up to vs. the rest of the series :-)
> 
> I still need to review that one closely, at which point I'm happy for
> you to take it.

It survived my tests, I'm continuing with other patches for 39 and I
have no problem with Ian's patches.

-- Steve


