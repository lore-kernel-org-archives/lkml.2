Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966653Ab2ERTO6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 15:14:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8911 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964976Ab2ERTO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 15:14:56 -0400
X-Authority-Analysis: v=2.0 cv=cssZYiEi c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=uChq6B4iKcYA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=VECvabN2eykZhoalTnAA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1337368492.7562.8.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] power, trace: add tracing for device_resume
From: Steven Rostedt <rostedt@goodmis.org>
To: Sameer Nanda <snanda@chromium.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, rob@landley.net, len.brown@intel.com,
        pavel@ucw.cz, rjw@sisk.pl, fweisbec@gmail.com, mingo@redhat.com,
        jkosina@suse.cz, standby24x7@gmail.com, jj@chaosbits.net,
        paulmck@linux.vnet.ibm.com, josh@joshtriplett.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Date: Fri, 18 May 2012 15:14:52 -0400
In-Reply-To: <CANMivWb3iOnoVtZ8G8kh9-vXPUfNFpSP=QWue0QztbkeZ+uE=Q@mail.gmail.com>
References: <1337365643-29261-1-git-send-email-snanda@chromium.org>
	 <20120518183756.GA3216@kroah.com>
	 <CANMivWb3iOnoVtZ8G8kh9-vXPUfNFpSP=QWue0QztbkeZ+uE=Q@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-18 at 11:57 -0700, Sameer Nanda wrote:

> AFAICT, they are used for something completely different -- help solve
> suspend/resume issues by saving a hash in the RTC of the last device
> that suspended/resumed.  They don't use the perf tracing mechanism at
> all.
> 

Also note that all tracepoints have timestamps attached to them. You do
not need to add deltas. Do that in the userspace tools that read the
timestamps and events. This way you can have one DECLARE_EVENT_CLASS and
three DEFINE_EVENTs. This will save space.

-- Steve


