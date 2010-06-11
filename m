Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759757Ab0FKS40 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 14:56:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37482 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752290Ab0FKS4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 14:56:25 -0400
MIME-Version: 1.0
In-Reply-To: <20100611103223.799d3ce0@nehalam>
References: <20100609183449.110905403@vyatta.com>
	<alpine.LFD.2.00.1006091144120.4506@i5.linux-foundation.org>
	<20100609115403.75ebb6cb@nehalam>
	<alpine.LFD.2.00.1006091203190.4506@i5.linux-foundation.org>
	<20100611103223.799d3ce0@nehalam>
Date: Fri, 11 Jun 2010 11:56:14 -0700
Message-ID: <AANLkTim7VHQEqdwfERzsBAuXLES1z4R-jLSGRLfbvoug@mail.gmail.com>
Subject: Re: [RFC] floppy: use single threaded workqueue
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 11, 2010 at 10:32 AM, Stephen Hemminger
<shemminger@vyatta.com> wrote:
> Fix races between timers and bottom half by using delayed work
> and a single threaded queue.
>
> Still needs more testing.

Looks simple and straightforward to me. Ack. (And ack on the "needs
more testing" part too, of course).

                  Linus
