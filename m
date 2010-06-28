Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752028Ab0F1Qqa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 12:46:30 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33998 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163Ab0F1QqZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 12:46:25 -0400
Subject: Re: futex: race in lock and unlock&exit for robust futex with PI?
From: Peter Zijlstra <peterz@infradead.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Darren Hart <dvhltc@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>,
       Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20100628163952.GD24127@tiehlicka.suse.cz>
References: <20100623091307.GA11072@tiehlicka.suse.cz>
	 <4C2417AA.4030306@us.ibm.com> <20100625082711.GA32765@tiehlicka.suse.cz>
	 <4C24ED34.9040808@us.ibm.com> <4C253D32.6040304@us.ibm.com>
	 <20100628144246.GA14201@tiehlicka.suse.cz>
	 <20100628153214.GA24127@tiehlicka.suse.cz>
	 <20100628155845.GC24127@tiehlicka.suse.cz>
	 <20100628163952.GD24127@tiehlicka.suse.cz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 28 Jun 2010 18:45:50 +0200
Message-ID: <1277743550.3561.136.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-28 at 18:39 +0200, Michal Hocko wrote:

> [I am sorry for bombarding you with emails]

You can lessen the burden on all of us by trimming your emails more
aggressively. Your last one has 4 dead tails in it.
