Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759131Ab0FJOqz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 10:46:55 -0400
Received: from casper.infradead.org ([85.118.1.10]:58219 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758555Ab0FJOqy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 10:46:54 -0400
Subject: Re: [PATCH 10/13] jump label v9: convert jump label to use a key
From: Peter Zijlstra <peterz@infradead.org>
To: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, mathieu.desnoyers@polymtl.ca,
       hpa@zytor.com, tglx@linutronix.de, rostedt@goodmis.org,
       andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
       mhiramat@redhat.com, fweisbec@gmail.com, avi@redhat.com,
       davem@davemloft.net, vgoyal@redhat.com, sam@ravnborg.org
In-Reply-To: <20100610135732.GC2410@redhat.com>
References: <cover.1276116186.git.jbaron@redhat.com>
	 <2a7e0be296375cf6658647c8a9c6cb208d875ac8.1276116186.git.jbaron@redhat.com>
	 <1276173826.2077.252.camel@twins>  <20100610135732.GC2410@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 10 Jun 2010 16:46:34 +0200
Message-ID: <1276181194.2077.404.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-10 at 09:57 -0400, Jason Baron wrote:

> right. I was going to clean that up in a followup. But you are right - I
> think it makes the code much clearer. will fix.

Please fold this patch into the previous patches. That makes the series
much more readable.
