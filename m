Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757942Ab1F1NRA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 09:17:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:34289 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754399Ab1F1NPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 09:15:49 -0400
X-Authority-Analysis: v=1.1 cv=IOX921YOuPvYFce5aSLzPVIStpiCPR9M8R83dyHW74w= c=1 sm=0 a=PnBdzaNuq4AA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=LbB4AWS0R9-XsfOnNaEA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [BUG?]3.0-rc4+ftrace+kprobe: set kprobe at instruction 'stwu'
 lead to system crash/freeze
From: Steven Rostedt <rostedt@goodmis.org>
To: ananth@in.ibm.com
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Yong Zhang <yong.zhang0@gmail.com>, paulus@samba.org,
        yrl.pp-manager.tt@hitachi.com, linuxppc-dev@lists.ozlabs.org,
        galak@kernel.crashing.org
In-Reply-To: <20110628104128.GA4310@in.ibm.com>
References: <BANLkTi=gx73d6-s-jqeke05SQYorpnzLVw@mail.gmail.com>
	 <1308911347.531.56.camel@gandalf.stny.rr.com>
	 <4E074671.7060100@hitachi.com> <20110627100104.GA24705@in.ibm.com>
	 <20110628104128.GA4310@in.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 28 Jun 2011 09:15:45 -0400
Message-ID: <1309266945.26417.2.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-28 at 16:11 +0530, Ananth N Mavinakayanahalli wrote:

> My access to a 32bit powerpc box is very limited. Also, embedded powerpc
> has had issues with gcc-4.6 while gcc-4.5 worked fine.

I'd work to debug this too, but I don't have access to a 32bit ppc
either. Although I've been told that people would send me one ;)

-- Steve


