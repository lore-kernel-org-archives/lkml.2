Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965266Ab2ESAYg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 20:24:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5721 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964782Ab2ESAYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 20:24:34 -0400
X-Authority-Analysis: v=2.0 cv=D8PF24tj c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=uChq6B4iKcYA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=EgozEG-oAAAA:8 a=wjpWQke1tntAgQoPrAwA:9 a=PUjeQqilurYA:10 a=DF_ZnzWi7xUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1337387071.7562.12.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] power, trace: add tracing for device_resume
From: Steven Rostedt <rostedt@goodmis.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Sameer Nanda <snanda@chromium.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        rob@landley.net, len.brown@intel.com, pavel@ucw.cz, fweisbec@gmail.com,
        mingo@redhat.com, jkosina@suse.cz, standby24x7@gmail.com,
        jj@chaosbits.net, paulmck@linux.vnet.ibm.com, josh@joshtriplett.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Date: Fri, 18 May 2012 20:24:31 -0400
In-Reply-To: <20120518230117.GA6016@kroah.com>
References: <1337365643-29261-1-git-send-email-snanda@chromium.org>
	 <1337375946.7562.11.camel@gandalf.stny.rr.com>
	 <CANMivWZ4ygG5R7ob_Q-pkAFpoKAkK_iQf3w2eiw5Gv65AbTYNw@mail.gmail.com>
	 <201205182346.02296.rjw@sisk.pl>
	 <CANMivWafYv8BU2_ez==+GGYWn54BM+iU6u7yLLs-2TOfm-1ftA@mail.gmail.com>
	 <20120518230117.GA6016@kroah.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-18 at 16:01 -0700, Greg KH wrote:
> You are kidding, right?  You have control over your test systems, don't
> bloat everyone's kernel by 5k just because your infrastructure is
> somehow something that you feel you can't change.
> 

It has been a while since I've done the trace point bloat check. I
should do it again to see where it stands. It may be less than 5k today,
but then again, it may be more.

-- Steve

