Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932489Ab1GNVyK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 17:54:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:64664 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932311Ab1GNVyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 17:54:08 -0400
X-Authority-Analysis: v=1.1 cv=PfPQ8rIoTcZsncbPZjVSZ7K0hy8Zc4hmL68r4VPNpKE= c=1 sm=0 a=exgflK5sixEA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=PA7olvEPNl62oqZ3IYsA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] [RFCv3] perf: robustify proc and debugfs file recording
From: Steven Rostedt <rostedt@goodmis.org>
To: Michael Neuling <mikey@neuling.org>
Cc: Sonny Rao <sonnyrao@chromium.org>, acme@redhat.com, anton@samba.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
In-Reply-To: <23957.1310679516@neuling.org>
References: <28585.1310602685@neuling.org>
	 <1310604019-10935-1-git-send-email-sonnyrao@chromium.org>
	 <1310612277.27864.5.camel@gandalf.stny.rr.com>
	 <10011.1310614483@neuling.org>
	 <1310647558.27864.19.camel@gandalf.stny.rr.com>
	 <23957.1310679516@neuling.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 14 Jul 2011 17:54:05 -0400
Message-ID: <1310680445.27864.58.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-15 at 07:38 +1000, Michael Neuling wrote:

> > Hmm, your patch has some serious issues caused by your mail client. When
> > saving (or looking at the raw message) I get this:
> 
> Crap, sorry.  
> 
> This is the same mail client I've used for sending patches for donkeys
> years so something much have under the covers with a distro upgrade or
> some such.  

Even after fixing it, I had really strange issues with using my script
to pull it in with git am. I kept getting this strange error about the
patch header missing or something. Don't have it anymore as I just
finally did it by manually git am (error), apply patch by hand, git add,
git am resolve, which seemed to do the trick.

-- Steve




