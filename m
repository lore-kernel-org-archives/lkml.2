Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083Ab1ASSNo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 13:13:44 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:61020 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210Ab1ASSNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 13:13:44 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=44vUGAvzfu8A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=7iJcpLsfajWkzCKs_9cA:9 a=KwbGS7bugUhUTjueG5YA:7 a=WG76R1CvTPdDgQFjTumcEWSMacoA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: Bug#609371: linux-image-2.6.37-trunk-sparc64: module scsi_mod:
 Unknown relocation: 36
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: David Miller <davem@davemloft.net>, richm@oldelvet.org.uk,
        609371@bugs.debian.org, ben@decadent.org.uk,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, mingo@redhat.com
In-Reply-To: <20110119161534.GB15031@Krystal>
References: <1295382144.12215.123.camel@gandalf.stny.rr.com>
	 <20110119050844.GA8776@Krystal>
	 <20110118.223247.241909079.davem@davemloft.net>
	 <20110118.232045.58440904.davem@davemloft.net>
	 <1295451961.12215.1291.camel@gandalf.stny.rr.com>
	 <20110119161534.GB15031@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 19 Jan 2011 13:13:42 -0500
Message-ID: <1295460822.12215.1389.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-19 at 11:15 -0500, Mathieu Desnoyers wrote:
> * Steven Rostedt (rostedt@goodmis.org) wrote:
> > After applying David's "remove align" patch, I got it to boot on x86_64
> > with the following two patches. I thought just adding the "align" to the
> > structure declaration would work, but it still failed on the syscall for
> > init_module. By removing the double "declaration" of event_exit_##sname,
> > removed this problem.
> > 
> > I'll test this on x86 32bit and PPC 64. If it works there, I'll push all
> > of them out for 38. Should these go to 37 stable too?
> 
> Please hold before adding these patches into git. They don't seem to address the
> underlying problem correctly. See the latest exchanges between David Miller and
> myself for more info.
> 
> We need to come up with something better than "it boots" as an explanation for
> the fix.

Yes, I agree that we should solve this issue correctly. But if there is
a work around to the problem, we could implement that if the real
solution is not in our grasp yet.

-- Steve


