Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754472Ab0ICHbT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 03:31:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:35440 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828Ab0ICHbS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 03:31:18 -0400
Subject: Re: IPC between application and xserver is causing extra context
 switches
From: Peter Zijlstra <peterz@infradead.org>
To: Pauli Nieminen <ext-pauli.nieminen@nokia.com>
Cc: ext Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Tony Lindgren <tony@atomide.com>, Jarkko Nikula <jhnikula@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pauli <suokkos@gmail.com>
In-Reply-To: <20100903071738.GA19353@squeeze>
References: <20100809150211.GA29771@burn-it> <20100901025817.GA6200@Krystal>
	 <20100903071738.GA19353@squeeze>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 03 Sep 2010 09:31:14 +0200
Message-ID: <1283499074.1783.59.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-09-03 at 10:17 +0300, Pauli Nieminen wrote:
> Scheduling at write is wrong because xserver doesn't know about client
> priorities. 

Waking up the client at write is correct because you don't know if there
is more to be written.

Really, your assumptions about when things schedule is wrong.


