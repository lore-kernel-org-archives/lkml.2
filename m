Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758905Ab2EVOvX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 10:51:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23559 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754086Ab2EVOvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 10:51:22 -0400
X-Authority-Analysis: v=2.0 cv=ae7jbGUt c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=FNlZJzECBvsA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=jikSmbCriIgnnYg3_f0A:9 a=XlodkIHP46ACp1HlPUMA:7 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1337698280.13348.47.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] net: Surpress kmemleak messages on sysctl paths
From: Steven Rostedt <rostedt@goodmis.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, viro@zeniv.linux.org.uk, tixxdz@opendz.org
Date: Tue, 22 May 2012 10:51:20 -0400
In-Reply-To: <878vgk1do2.fsf@xmission.com>
References: <1337647392.13348.14.camel@gandalf.stny.rr.com>
	 <878vgk1do2.fsf@xmission.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-22 at 08:41 -0600, Eric W. Biederman wrote:
> Steven Rostedt <rostedt@goodmis.org> writes:
> 
> > The network code allocates ctl_table_headers that are used for the life
> > of the kernel. These headers are registered and never unregistered. The
> > head pointer is allocated and not referenced, as it never needs to be
> > unregistered, and the kmemleak detector triggers these as false
> > positives:
> 
> The fix for this should already be merged into Linus's tree from the
> net-next tree for 3.5.

Ah, I didn't look at net-next. I just looked at 3.4 and didn't see
anything. If that's the case, simply ignore :-)

-- Steve


