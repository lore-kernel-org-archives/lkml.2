Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629Ab2GaTLp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 15:11:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22785 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840Ab2GaTLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 15:11:44 -0400
X-Authority-Analysis: v=2.0 cv=StQSGYy0 c=1 sm=0 a=s5Htg7xnQOKvHEu9STBOug==:17 a=OpT9cpI26MMA:10 a=7Npo2C4X2bcA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=HtK6XFx8SY3d_bXckHcA:9 a=PUjeQqilurYA:10 a=s5Htg7xnQOKvHEu9STBOug==:117
X-Cloudmark-Score: 0
X-Originating-IP: 72.230.195.127
Message-ID: <1343761902.27983.67.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH RT 05/12] slab: Prevent local lock deadlock
From: Steven Rostedt <rostedt@goodmis.org>
To: frank.rowand@am.sony.com
Cc: "Rowand, Frank" <Frank_Rowand@sonyusa.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "chris.pringle@miranda.com" <chris.pringle@miranda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Carsten Emde <C.Emde@osadl.org>, John Kacur <jkacur@redhat.com>
Date: Tue, 31 Jul 2012 15:11:42 -0400
In-Reply-To: <50182B44.8090100@am.sony.com>
References: <20120718223910.898476857@goodmis.org>
			 <20120718223957.856443728@goodmis.org> <5011DD9B.1030901@am.sony.com>
		 <1343697755.27983.17.camel@gandalf.stny.rr.com>
		 <50174158.4000408@am.sony.com>
	 <1343701935.27983.18.camel@gandalf.stny.rr.com>
	 <50182B44.8090100@am.sony.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-31 at 12:00 -0700, Frank Rowand wrote:

> > Yeah, my root fs is on the sdcard. Did you get this bug every time or
> > was it sporadic?
> 
> I get it every boot.

Can you try it with an SD card? I can set it up for nfs as well, but
that would take a bit of time.

-- Steve


