Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935356Ab0KQTAl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 14:00:41 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:40983 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935342Ab0KQTAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 14:00:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=kWqDOEHXl/dhRiXQwi7TXZl65jQYia5EpzIJ9JHi1SeQSBFwPwO/pGRbzsLvldViRF
         GMn0p7OA4AxmMXgkAgBC9LoGMVErv1jpz/CydTXnpbxrBxBnbzwrzzQpWGGqXxDlCPhW
         x4RKYB5krXx+VwL+kx98hNlENFsbjNmqt+cl8=
MIME-Version: 1.0
In-Reply-To: <1289964840.30543.22.camel@gandalf.stny.rr.com>
References: <alpine.LFD.2.00.1011162103580.2900@localhost6.localdomain6>
	<20101117013700.GA3290@thunk.org>
	<1289958460.30543.13.camel@gandalf.stny.rr.com>
	<20101117031609.GE3290@thunk.org>
	<1289964840.30543.22.camel@gandalf.stny.rr.com>
Date: Wed, 17 Nov 2010 14:00:39 -0500
X-Google-Sender-Auth: g1L962yKxakM1jUA7c7qIiEGNuk
Message-ID: <AANLkTi=1zYp7NsWy36Tg5Hwz4h0co3mMgeYAWZ4HasZo@mail.gmail.com>
Subject: Re: [ANNOUNCE] New utility: 'trace'
From: Bob Copeland <me@bobcopeland.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Ted Ts'o" <tytso@mit.edu>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tom Zanussi <tzanussi@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Jason Baron <jbaron@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Christoph Hellwig <hch@lst.de>, Pekka Enberg <penberg@kernel.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 10:34 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> (*) Currently in trace-cmd I have plugins. These plugins are simple
> functions to read events and either output better displays of the event
> or do something special (Avi wrote some for his kvm events).

We also use this for debugging some wireless drivers.  The (unstable)
raw events can capture entire packets and produce psuedo-pcap files with
a plugin so we can compare what we thought went over the air versus what
actually did, and correlate them with api-level tracepoints in upper
layers.  It's perhaps a bit of a bending of the infrastructure, but one
that has been helpful.

-- 
Bob Copeland %% www.bobcopeland.com
