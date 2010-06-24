Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472Ab0FXNXm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 09:23:42 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64130 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754810Ab0FXNXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 09:23:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=UZDhQb84pMiTLdjMVOx55P5kvC7t56cIfqnFoctZ41Sc/JFQuobvC69JtJZmLbvCZL
         iJN/dsVAuZpqjm67+CNC5wL7VY9TYhLxma6sKKwcrE/TtdSh6xA5OG+BKJrEFbOlxRVj
         XkvU7cFaGf7j/QJ9vXPsMA6FC+ijRufUgndSQ=
Date: Thu, 24 Jun 2010 17:23:34 +0400
From: Ilya Loginov <isloginov@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] fix problem with reschenduling in rest_init
 (2.6.35-rc3)
Message-Id: <20100624172334.ca7e9bef.isloginov@gmail.com>
In-Reply-To: <1277385096.1875.974.camel@laptop>
References: <20100624001148.61e9da1c.isloginov@gmail.com>
	<1277385096.1875.974.camel@laptop>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jun 2010 15:11:36 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> However I suspect the ordering is like it is because we want init to
> have pid 1, if we were to re-order like you suggest kthreadd will end up
> with pid 1 and init with pid 2.

Strange, but init does not die after I did this. Fix me if I wrong, but it wants
to have pid 1, and die in other case.

Interesting...

-- 
Ilya Loginov <isloginov@gmail.com>
