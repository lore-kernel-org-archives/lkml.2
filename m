Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955Ab0C2ORn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 10:17:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:39243 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030Ab0C2ORm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 10:17:42 -0400
Subject: Re: [PATCH 3/4] scheduler: replace migration_thread with cpuhog
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
       rusty@rustcorp.com.au, sivanich@sgi.com, heiko.carstens@de.ibm.com,
       torvalds@linux-foundation.org, mingo@elte.hu, dipankar@in.ibm.com,
       josh@freedesktop.org, paulmck@linux.vnet.ibm.com,
       akpm@linux-foundation.org, arjan@infradead.org
In-Reply-To: <20100329135700.GA25423@redhat.com>
References: <1268815251-31407-1-git-send-email-tj@kernel.org>
	 <1268815251-31407-4-git-send-email-tj@kernel.org>
	 <20100329135700.GA25423@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Mar 2010 16:17:37 +0200
Message-ID: <1269872257.12097.341.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-29 at 15:57 +0200, Oleg Nesterov wrote:
> As I said, personally I like these changes very much. Even if I can't ack them
> I'd like to add my vote.

Well, I like what they do, but I hate the name and I don't like how we
end up with two interfaces that do pretty much the same thing, this new
hog thing and stopmachine.

I much prefer to keep the stopmachine name and make that into a usable
interface.

