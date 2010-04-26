Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371Ab0DZVm1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 17:42:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11078 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754509Ab0DZVmZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 17:42:25 -0400
Date: Mon, 26 Apr 2010 17:41:56 -0400
From: Dave Jones <davej@redhat.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       peterz@infradead.org, tglx@linutronix.de, cpufreq@vger.kernel.org
Subject: Re: [PATCH 0/7] Fix performance issue with ondemand governor
Message-ID: <20100426214156.GA32326@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Arjan van de Ven <arjan@infradead.org>,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	mingo@elte.hu, peterz@infradead.org, tglx@linutronix.de,
	cpufreq@vger.kernel.org
References: <20100418115949.7b743898@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100418115949.7b743898@infradead.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 18, 2010 at 11:59:49AM -0700, Arjan van de Ven wrote:
 > There have been various reports of the ondemand governor causing some
 > serious performance issues, one of the latest ones from Andrew.
 > There are several fundamental issues with ondemand (being worked on),
 > but the report from Andrew can be fixed relatively easily.
 > 
 > The fundamental issue is that ondemand will go to a (too) low CPU
 > frequency for workloads that alternatingly disk and CPU bound...

given the scheduler changes, these probably make more sense to go
via one of Ingo's trees ?
If everyone agrees, feel free to add my Signed-off-by:

	Dave

