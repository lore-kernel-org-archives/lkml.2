Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348Ab0IILft (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 07:35:49 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33458 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408Ab0IILfr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 07:35:47 -0400
Subject: Re: perf events over (net) console?
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Harald Gustafsson <hgu1972@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Harald Gustafsson <harald.gustafsson@ericsson.com>,
        Song Yuan <song.yuan@ericsson.com>,
        Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <20100909112940.GA5267@nowhere>
References: <AANLkTi=yeHyOeewm9tdsHRtj+=d+vE5=NRKGaPyq_yGH@mail.gmail.com>
	 <1284031141.402.1.camel@laptop>  <20100909112940.GA5267@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 09 Sep 2010 13:35:42 +0200
Message-ID: <1284032142.402.5.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-09 at 13:29 +0200, Frederic Weisbecker wrote:
> But if we bring the splice support,

Even simply write() from the mmap() buffer isn't terribly expensive. But
yeah, once we fix splice not to always copy that could be even better.

Splice() is on the todo list, but it needs significant user-interface
work and I'm rather busy..
