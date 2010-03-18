Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754Ab0CRVTg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 17:19:36 -0400
Received: from gate.crashing.org ([63.228.1.57]:56848 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752230Ab0CRVTe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 17:19:34 -0400
Subject: Re: 64-syscall args on 32-bit vs syscall()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: munroesj@us.ibm.com
Cc: Andreas Schwab <schwab@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ulrich Drepper <drepper@redhat.com>, David Miller <davem@davemloft.net>,
       ralf@linux-mips.org, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel@teksavvy.com,
       torvalds@linux-foundation.org
In-Reply-To: <1268931823.19726.127.camel@spokane1.rchland.ibm.com>
References: <20100315134449.GB1653@linux-mips.org>
	 <4B9E4EB1.9010800@zytor.com> <4B9E59B7.6060405@redhat.com>
	 <20100315.120004.209998642.davem@davemloft.net>
	 <4B9E8D67.8040209@zytor.com> <1268685311.2335.38.camel@pasglop>
	 <1268776570.19726.98.camel@spokane1.rchland.ibm.com>
	 <1268785874.2335.137.camel@pasglop> <4BA06E1B.2040706@redhat.com>
	 <1268816179.2335.187.camel@pasglop> <4BA11FD2.2090104@zytor.com>
	 <1268858134.2335.198.camel@pasglop> <4BA1412C.6070008@zytor.com>
	 <1268866720.2335.204.camel@pasglop>
	 <1268928480.19726.123.camel@spokane1.rchland.ibm.com>
	 <m37hp9y51p.fsf@hase.home>
	 <1268931823.19726.127.camel@spokane1.rchland.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 19 Mar 2010 08:18:22 +1100
Message-ID: <1268947102.2335.236.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-18 at 12:03 -0500, Steven Munroe wrote:
> Sorry in and long are compatible in 32-bit but not long long.
> 
> int and long are not compatible in 64-bit
> 
> It is hard the keep all the nodes and arguments straight.
> 
> But the concern about changing the prototype and are people actually
> using the prototype are still valid.

Well, using the macro trick instead would fix that problem, code
wouldn't build if it doesn't include unistd.h :-)

Cheers,
Ben.


