Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756589Ab1CAP70 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 10:59:26 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:44970 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753070Ab1CAP7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 10:59:25 -0500
Subject: Re: [PATCH 3/6] perf record: add time-of-day option
From: Peter Zijlstra <peterz@infradead.org>
To: David Ahern <daahern@cisco.com>
Cc: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        acme@ghostprotocols.net, mingo@elte.hu, fweisbec@gmail.com,
        paulus@samba.org, tglx@linutronix.de
In-Reply-To: <4D6D13C6.5020807@cisco.com>
References: <1298865151-23656-1-git-send-email-daahern@cisco.com>
	 <1298865151-23656-4-git-send-email-daahern@cisco.com>
	 <1298989751.5226.863.camel@laptop>  <4D6D0438.2090901@cisco.com>
	 <1298993714.5226.871.camel@laptop>  <4D6D13C6.5020807@cisco.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Mar 2011 17:00:50 +0100
Message-ID: <1298995250.5226.882.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-01 at 08:41 -0700, David Ahern wrote:

> realtime-clock counter is created with a period N. How do you correlate
> perf_clock to time-of-day until now + N? 

You scan fwd? Since its at most N time ahead you're scanning fwd its
still constant time.

Thing is, I'm really not convinced this is a very useful ioctl() in
generic, and ioctl()s really need a good justification to add.

