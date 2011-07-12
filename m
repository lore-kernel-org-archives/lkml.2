Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756473Ab1GLX3W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 19:29:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:36910 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840Ab1GLX3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 19:29:22 -0400
X-Authority-Analysis: v=1.1 cv=IOX921YOuPvYFce5aSLzPVIStpiCPR9M8R83dyHW74w= c=1 sm=0 a=NyiLX209gCUA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=iJKeavrR0B98nSgvgmsA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] [RFC] perf: robustify proc and debugfs file recording
From: Steven Rostedt <rostedt@goodmis.org>
To: Sonny Rao <sonnyrao@chromium.org>
Cc: acme@redhat.com, anton@samba.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
In-Reply-To: <CAPz6YkWhf-6U_s=ZaLZx6i2DUa7-TgBcs4f08T6XACrwqDHaww@mail.gmail.com>
References: <1310505348-20163-1-git-send-email-sonnyrao@chromium.org>
	 <1310511415.3931.11.camel@gandalf.stny.rr.com>
	 <CAPz6YkWhf-6U_s=ZaLZx6i2DUa7-TgBcs4f08T6XACrwqDHaww@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 12 Jul 2011 19:29:19 -0400
Message-ID: <1310513359.3931.12.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-12 at 16:01 -0700, Sonny Rao wrote:

> I sure am... the thing we're trying to do here is analyze our boot time
> and udev is asynchronously loading modules in the background while
> perf is starting up.

OK, I'll take a deeper look at these patches tomorrow.

-- Steve


