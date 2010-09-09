Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596Ab0IILTH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 07:19:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:54868 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100Ab0IILTF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 07:19:05 -0400
Subject: Re: perf events over (net) console?
From: Peter Zijlstra <peterz@infradead.org>
To: Harald Gustafsson <hgu1972@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Harald Gustafsson <harald.gustafsson@ericsson.com>,
        Song Yuan <song.yuan@ericsson.com>
In-Reply-To: <AANLkTi=yeHyOeewm9tdsHRtj+=d+vE5=NRKGaPyq_yGH@mail.gmail.com>
References: <AANLkTi=yeHyOeewm9tdsHRtj+=d+vE5=NRKGaPyq_yGH@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 09 Sep 2010 13:19:01 +0200
Message-ID: <1284031141.402.1.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-09 at 13:06 +0200, Harald Gustafsson wrote:
> Hi,
> 
> We would like to monitor the perf events continuously on a remote
> machine. Does it exist a solution (in the kernel) to direct the output
> to a console or maybe even a netconsole? We would like to avoid a user
> space application to transfer it, due to that the machine will be
> running a test which will heavily load it and we want to avoid as many
> unrelated user space tasks as possible. If not mainlined does anyone
> have a patch for this?

No, and its a daft requirement.

You need a process context anyway to read the data and send it to
whatever place you want it.

Putting that in-kernel serves no purpose what so ever.
