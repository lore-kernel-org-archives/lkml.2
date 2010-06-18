Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757972Ab0FRDpm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 23:45:42 -0400
Received: from ozlabs.org ([203.10.76.45]:39456 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756860Ab0FRDpk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 23:45:40 -0400
Date: Fri, 18 Jun 2010 13:45:39 +1000
From: Tony Breeds <tony@bakeyournoodle.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Jason Baron <jbaron@redhat.com>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de, rostedt@goodmis.org, andi@firstfloor.org,
       roland@redhat.com, rth@redhat.com, mhiramat@redhat.com,
       fweisbec@gmail.com, avi@redhat.com, vgoyal@redhat.com, sam@ravnborg.org
Subject: Re: [PATCH 00/13] jump label v9
Message-ID: <20100618034539.GD16706@ozlabs.org>
Mail-Followup-To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	Jason Baron <jbaron@redhat.com>, David Miller <davem@davemloft.net>,
	linux-kernel@vger.kernel.org, mingo@elte.hu, hpa@zytor.com,
	tglx@linutronix.de, rostedt@goodmis.org, andi@firstfloor.org,
	roland@redhat.com, rth@redhat.com, mhiramat@redhat.com,
	fweisbec@gmail.com, avi@redhat.com, vgoyal@redhat.com,
	sam@ravnborg.org
References: <cover.1276116186.git.jbaron@redhat.com>
 <20100614.204759.226765762.davem@davemloft.net>
 <20100615142811.GB2750@redhat.com>
 <20100615154440.GA9224@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100615154440.GA9224@Krystal>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 15, 2010 at 11:44:40AM -0400, Mathieu Desnoyers wrote:

> It makes me wonder if anyone had success building a gcc 4.5
> Intel-to-sparc64 cross-compiler ? Usually, the crosstool-like suites are
> a few versions behind. I'm aware that this is not trivial, as
> cross-compilers have a tendency to refuse to get built in certain
> occasions (such as being a recent less tested version). I'd recommend
> you focus on this as a first step before resubmitting.

I'm building (and uploading to kernel.org[1]) 4.4.4 and 4.5.0 toolchains.
They're untested on anything otyher than the system I built them on.

Give it 24 hours and then try'em

Yours Tony
[1] http://kernel.org/pub/tools/crosstool/files/bin/${host_arch}/ [2]
[2] currently only i686 and x86_64, powerpc64 are comming.
