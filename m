Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761070Ab2COLN6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 07:13:58 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56635 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757882Ab2COLNz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 07:13:55 -0400
Message-ID: <1331810014.18960.172.camel@twins>
Subject: Re: [PATCH v2 02/13] memcg: Kernel memory accounting infrastructure.
From: Peter Zijlstra <peterz@infradead.org>
To: Glauber Costa <glommer@parallels.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Suleiman Souhlal <ssouhlal@FreeBSD.org>, cgroups@vger.kernel.org,
        suleiman@google.com, penberg@kernel.org, cl@linux.com,
        yinghan@google.com, hughd@google.com, gthelen@google.com,
        dan.magenheimer@oracle.com, hannes@cmpxchg.org, mgorman@suse.de,
        James.Bottomley@HansenPartnership.com, linux-mm@kvack.org,
        devel@openvz.org, linux-kernel@vger.kernel.org
Date: Thu, 15 Mar 2012 12:13:34 +0100
In-Reply-To: <4F61CD63.4090007@parallels.com>
References: <1331325556-16447-1-git-send-email-ssouhlal@FreeBSD.org>
	 <1331325556-16447-3-git-send-email-ssouhlal@FreeBSD.org>
	 <4F5C5E54.2020408@parallels.com>
	 <20120313152446.28b0d696.kamezawa.hiroyu@jp.fujitsu.com>
	 <4F5F236A.1070609@parallels.com>
	 <20120314091526.3c079693.kamezawa.hiroyu@jp.fujitsu.com>
	 <4F608F25.3010700@parallels.com> <4F613C5B.8030304@jp.fujitsu.com>
	 <4F61CD63.4090007@parallels.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-15 at 15:07 +0400, Glauber Costa wrote:
> But since I never heard of any machine with
> 9223372036854775807 bytes of memory, that is true even for the root memcg 

What, you don't have more than 8 exabyte of memory in your laptop !?
Surely you're due for an upgrade then.
