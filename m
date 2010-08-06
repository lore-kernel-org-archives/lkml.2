Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934176Ab0HFA3b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 20:29:31 -0400
Received: from smtp-out.google.com ([216.239.44.51]:12215 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932168Ab0HFA30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 20:29:26 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=pKxD8WsRSZdMwRDtz7tXP5ebodhFIUoZBzUla95sdqIAIrtKvDDR7xbDnsd8gWWca
	vaBYIDQBJt01j6v48goFA==
MIME-Version: 1.0
In-Reply-To: <201008060141.46109.rjw@sisk.pl>
References: <20100801054816.GI2470@linux.vnet.ibm.com>
	<201008051734.06736.rjw@sisk.pl>
	<AANLkTi=kDx440MrLnQEcT46b3gkahU5ZGc0oWrWF-D2g@mail.gmail.com>
	<201008060141.46109.rjw@sisk.pl>
Date: Thu, 5 Aug 2010 17:29:24 -0700
Message-ID: <AANLkTin245wZsxeUh2HuONHqDNXFWpyzPsYv4PPuZYSb@mail.gmail.com>
Subject: Re: Attempted summary of suspend-blockers LKML thread
From: Brian Swetland <swetland@google.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>, david@lang.hm,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Arjan van de Ven <arjan@infradead.org>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        pavel@ucw.cz, florian@mickler.org, stern@rowland.harvard.edu,
        peterz@infradead.org, tglx@linutronix.de, alan@lxorguk.ukuu.org.uk
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/8/5 Rafael J. Wysocki <rjw@sisk.pl>:
>>
>> Our wakelock stats currently have
>> (name,)count,expire_count,wake_count,active_since,total_time,sleep_time,max_time
>> and last_change. Not all of these are equally important (total_time is
>> most important followed by active_since), but you only have count.
>> Also as discussed before, many wakelocks/suspendblockers are not
>> associated with a struct device.
>
> OK
>
> How much of that is used in practice and what for exactly?
>
> Do you _really_ have to debug the wakelocks in drivers that much?

Debugging power related issues is pretty critical to building
competitive mobile devices.

Throughout the several months of this discussion I have been
continually scratching my head at this "debugability considered
harmful" attitude that I see in reaction to our interest in having the
ability (gated behind a config option even -- really, that'd be fine,
not everyone need enable it) to gather useful stats and examine the
state of the system.

At this point it sounds like there's no interest in the solution we
have, which works and has worked for a few years, and has been revised
10+ times based on feedback here, and no interest in providing a
solution that accomplishes similar functionality, so perhaps it's time
for us to cut our losses and just go back to maintaining our patches
instead of having the same arguments over and over again.

Brian
