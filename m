Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691Ab1A2Ady (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 19:33:54 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37489 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753362Ab1A2Adx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 19:33:53 -0500
Date: Fri, 28 Jan 2011 16:33:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Leonardo  L. P. da Mata" <barroca@gmail.com>
Cc: linux-kernel@vger.kernel.org, Guo-Fu Tseng <cooldavid@cooldavid.org>,
        netdev@vger.kernel.org
Subject: Re: jme driver loses connection after resuming from suspend
Message-Id: <20110128163315.1e4e8346.akpm@linux-foundation.org>
In-Reply-To: <AANLkTikrKEY7Zt5HvxQcJLk9eGne0BGD82NFEiWO4smt@mail.gmail.com>
References: <AANLkTikrKEY7Zt5HvxQcJLk9eGne0BGD82NFEiWO4smt@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc's added)

On Fri, 28 Jan 2011 16:03:11 -0200
"Leonardo  L. P. da Mata" <barroca@gmail.com> wrote:

> Hello, i'm testing the kernel 2.6.37 on my hardware, Once connect on
> wired network, i call the suspend with:
> echo "mem" >/sys/power/state
> 
> The system goes on suspend. After resuming from suspend, the network card
> cannot be used anymore.
> 
> 
> The bug is reported here:
>  https://bugzilla.kernel.org/show_bug.cgi?id=27692
> 
> Can you please point me to similar problems on other network cards so
> i can get possible solutions on this.

