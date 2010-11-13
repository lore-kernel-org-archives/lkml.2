Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468Ab0KMWyG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 17:54:06 -0500
Received: from casper.infradead.org ([85.118.1.10]:52000 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754348Ab0KMWyE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 17:54:04 -0500
Subject: Re: Kernel rwlock design, Multicore and IGMP
From: Peter Zijlstra <peterz@infradead.org>
To: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Cypher Wu <cypher.w@gmail.com>,
        linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
In-Reply-To: <20101112081945.GA5949@cr0.nay.redhat.com>
References: <AANLkTikvT=x9eBovn2-m6HLqk7wyXSAR3sc9jCQ0C6mL@mail.gmail.com>
	 <1289489007.17691.1310.camel@edumazet-laptop>
	 <AANLkTik93QUQxSDmwd4Qj-gXQiWWPzd68JPAYAHBAsHR@mail.gmail.com>
	 <20101112071323.GB5660@cr0.nay.redhat.com>
	 <1289546874.17691.1774.camel@edumazet-laptop>
	 <20101112081945.GA5949@cr0.nay.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 13 Nov 2010 23:54:20 +0100
Message-ID: <1289688860.2109.401.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-12 at 16:19 +0800, Américo Wang wrote:
> 
> Just for record, both Tile and X86 implement rwlock with a write-bias,
> this somewhat reduces the write-starvation problem. 

x86 does no such thing.
