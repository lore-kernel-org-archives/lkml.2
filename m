Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998Ab0KZN1N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 08:27:13 -0500
Received: from canuck.infradead.org ([134.117.69.58]:37801 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753638Ab0KZN1M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 08:27:12 -0500
Subject: Re: [PATCH] perf: add GCC optimization to memory allocating
 functions
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: dave@gnu.org
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1290777864.2373.2.camel@cowboy>
References: <1290777864.2373.2.camel@cowboy>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 26 Nov 2010 14:27:20 +0100
Message-ID: <1290778040.2145.145.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-26 at 10:24 -0300, Davidlohr Bueso wrote:
> From: Davidlohr Bueso <dave@gnu.org>
> 
> We can benefit from the alloc_size attribute in xrealloc and zalloc.

What's this alloc_size attribute do?

