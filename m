Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756125Ab0FYN2y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 09:28:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11615 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754504Ab0FYN2x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 09:28:53 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100625125527.GA3187@jolsa.bos.redhat.com>
References: <20100625125527.GA3187@jolsa.bos.redhat.com> <20100616160844.GB1893@jolsa.lab.eng.brq.redhat.com> <1276691043-12694-1-git-send-email-jolsa@redhat.com> <1276692314.2632.66.camel@edumazet-laptop> <20100616125708.GA1893@jolsa.lab.eng.brq.redhat.com> <1276693837.2632.75.camel@edumazet-laptop> <6118.1276818640@redhat.com> <20100619120101.GA2043@jolsa.colubris.lan> 
To: Jiri Olsa <jolsa@redhat.com>
Cc: dhowells@redhat.com, Eric Dumazet <eric.dumazet@gmail.com>,
       linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] cred - synchronize rcu before releasing cred
Date: Fri, 25 Jun 2010 14:28:10 +0100
Message-ID: <23247.1277472490@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Olsa <jolsa@redhat.com> wrote:

> do I need to send this some one/place else?
> not sure it's going to be picked up..

Post it to linux-security-module@vger.kernel.org with the ACKs you've
collected added in.

David
