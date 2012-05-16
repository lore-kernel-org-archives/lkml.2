Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759185Ab2EPN15 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 09:27:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26880 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753Ab2EPN1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 09:27:53 -0400
X-Authority-Analysis: v=2.0 cv=D8PF24tj c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=g_LhDMiRcOYA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=8pif782wAAAA:8 a=Dyvoxc0TmwaqMlCFGBIA:9 a=pMqmfDVYBsvYamM696wA:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1337174871.6724.40.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH v22] edac, ras/hw_event.h: use events to handle hw issues
From: Steven Rostedt <rostedt@goodmis.org>
To: Borislav Petkov <bp@amd64.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Date: Wed, 16 May 2012 09:27:51 -0400
In-Reply-To: <20120516131656.GA2202@aftab.osrc.amd.com>
References: <20120511102527.GI8913@aftab.osrc.amd.com>
	 <4FAD081C.5000704@redhat.com> <20120511172430.GB17299@aftab.osrc.amd.com>
	 <4FAD5CAD.90508@redhat.com> <20120514133404.GE4231@aftab.osrc.amd.com>
	 <4FB1163D.3010302@redhat.com> <20120515150957.GC27806@aftab.osrc.amd.com>
	 <4FB27EDC.8040001@redhat.com> <20120515163855.GE27806@aftab.osrc.amd.com>
	 <4FB38DDF.7030009@redhat.com> <20120516131656.GA2202@aftab.osrc.amd.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-16 at 15:16 +0200, Borislav Petkov wrote:

> > >>>>     Of course, any userspace tools meant to handle errors should not parse
> > >>>>     the above data. They should, instead, use the binary fields provided by
> > >>>>     the tracepoint, mapping them directly into their MIBs.
> > >>>
> > >>> What is a MIB?
> > >>
> > >> Management Information Base. This is how anyone that works with Element
> > >> Management calls the model of information that represents each management
> > >> property. It is generally written using ITU-T ASN.1 syntax. Almost all
> > >> management software use that.
> > >>
> > >> [1] http://en.wikipedia.org/wiki/Management_information_base
> > > 
> > > That looks like an ACPI or some other idiotic spec speak, pls remove it.
> > 
> > No, MIB is not an idiotic speak. It is a widely-used term, older than TCP/IP, 
> > and defined by ITU-T (M.3000 series) and by ISO.
> > 
> > It is used by everybody that knows a little bit about error management,
> > as all management systems and protocols (like SNMP) are based on MIB
> > concepts. This concept is also used by other international forums, like
> > IETF, to define the Information Model to be used to manage the machine
> > and/or network resources. For example, the TCP/IP stack management base
> > is defined at IETF RFC1213.
> 
> More idiotic drivel.
> 
> Oh, well, you won't let go of this crap, so at least add the wikipedia
> URL to the "MIB" reference so that mere mortals like me who don't know
> jack of error management can understand what you're talking about.

I should change goodmis to goodmib. That sounds better. For those that
don't know, goodmis comes from a project I started a long time ago. 

 Good Object Oriented Database Management Information System

Which was inspired by a database I wrote at a company I worked for in
the 90's. Called "Object Based Information v1" or OBI-1.

:-)

-- Steve


