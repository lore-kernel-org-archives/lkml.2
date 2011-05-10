Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124Ab1EJJO4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 05:14:56 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:38932 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab1EJJOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 05:14:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=ZBa8c5WdcXk1woGnFRdsO1XFJzvmb8igsunfINZNCDXO7bWCjSjbCOD+pe67soVJiy
         QU9TxeuLkGjnYAgc0vh8JOq5XQTbf1KpxuUl1+upYnVnIXUt6DqN0gupZxX+uujUvCE6
         5wGgzzbRLV/iQwP9Dhvbhu8NAail03NIGYhpk=
MIME-Version: 1.0
In-Reply-To: <20110510084410.GD27426@elte.hu>
References: <1304713252.25414.2532.camel@gandalf.stny.rr.com>
	<BANLkTim9YvResB+PwRp7QTK-a5VNg2PvmQ@mail.gmail.com>
	<20110507065803.GA23414@elte.hu>
	<1304765110.25414.2564.camel@gandalf.stny.rr.com>
	<20110507144402.GC2859@elte.hu>
	<1304788829.11129.57.camel@frodo>
	<20110507190033.GA11465@elte.hu>
	<1304996847.2969.151.camel@frodo>
	<20110510080918.GB27426@elte.hu>
	<4DC8F831.2010404@linux.intel.com>
	<20110510084410.GD27426@elte.hu>
Date: Tue, 10 May 2011 12:14:54 +0300
X-Google-Sender-Auth: 0OZTCZ_7ng-aG-2uFLq7n4FIIg8
Message-ID: <BANLkTinfZ9ypJoivVg6Y9EwGdAZ2QmMZuA@mail.gmail.com>
Subject: Re: Fix powerTOP regression with 2.6.39-rc5
From: Pekka Enberg <penberg@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
        Steven Rostedt <rostedt@goodmis.org>, David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Michael Rubin <mrubin@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christoph Hellwig <hch@infradead.org>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 10, 2011 at 11:44 AM, Ingo Molnar <mingo@elte.hu> wrote:
>> >Steve, we even joked about that, that if we continue like this we'll end up
>> >with an XML parser ... I requested several changes to the description format so
>> >that it becomes more human readable.
>>
>> frankly, for software, XML is easier to deal with than the human
>> readable form.
>
> Yes, absolutely - still i think keeping it human readable is important.

This is getting slightly off-topic but there are good human readable
formats that are also easily parseable by computers. JSON and YAML
come to mind.
