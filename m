Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756375Ab1BJUK7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 15:10:59 -0500
Received: from casper.infradead.org ([85.118.1.10]:60341 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099Ab1BJUK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 15:10:58 -0500
Subject: Re: [PATCH 1/1] perf tools: Fix thread_map event synthesizing in
 top and record
From: Peter Zijlstra <peterz@infradead.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Jeff Moyer <jmoyer@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
In-Reply-To: <20110210200000.GF20676@ghostprotocols.net>
References: <1297363899-21466-1-git-send-email-acme@infradead.org>
	 <1297363899-21466-2-git-send-email-acme@infradead.org>
	 <x49aai38yqa.fsf@segfault.boston.devel.redhat.com>
	 <20110210200000.GF20676@ghostprotocols.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Feb 2011 21:11:45 +0100
Message-ID: <1297368705.5226.23.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-10 at 18:00 -0200, Arnaldo Carvalho de Melo wrote:
> And do you or others have any
> > interest in trying to work out why perf is hanging my system?
> 
> Peter? 

Its on the todo list, but stuff seems to be coming in faster than I can
process once again :/

