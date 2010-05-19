Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757534Ab0ESKiP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 06:38:15 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49957 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757369Ab0ESKiJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 06:38:09 -0400
Subject: Re: schedule() && prev/current (Was: [PATCH 3/3] Make
 get_current() __attribute__((const)))
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Yong Zhang <yong.zhang0@gmail.com>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100519102743.GA10040@redhat.com>
References: <20100518164537.6194.73366.stgit@warthog.procyon.org.uk>
	 <20100518164547.6194.94193.stgit@warthog.procyon.org.uk>
	 <20100518212220.GA5092@redhat.com> <1274250079.5605.9967.camel@twins>
	 <20100519102743.GA10040@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 19 May 2010 12:37:45 +0200
Message-ID: <1274265465.5605.10564.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-19 at 12:27 +0200, Oleg Nesterov wrote:

> Now suppose that A calls schedule() and we switch to B. When switch_to()
> returns on B's context, this context (register/stack) matches the previous
> context which was used by B when it in turn called schedule(), correct?

Ah, right, you always schedule back to where you came from,... I
shouldn't try and write emails before the morning juice hits ;-)


