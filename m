Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466Ab0F3IdF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 04:33:05 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52765 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009Ab0F3IdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 04:33:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=g3+ySwSse0+T91Mx1j0SZN1PROq0OyGxLoLjNclHC6r7NA+gURYzinF/aHupy5O9b4
         7UOpyqmm5EJcDtSkEPHFy0RFkIFJiQQXzWcIse81owfVq4Nef9K+aiIIlgt+t3vH5HEL
         06cDlbg9Nk3UaFRHDAyYF1g4BkmQPOCy40W2w=
Date: Wed, 30 Jun 2010 12:32:49 +0400
From: Ilya Loginov <isloginov@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, torvalds@linux-foundation.org,
       randy.dunlap@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] init: Fix race between init and kthreadd -v3
Message-Id: <20100630123249.ce966c83.isloginov@gmail.com>
In-Reply-To: <1277736661.3561.110.camel@laptop>
References: <20100624001148.61e9da1c.isloginov@gmail.com>
	<1277385096.1875.974.camel@laptop>
	<20100624172334.ca7e9bef.isloginov@gmail.com>
	<1277715689.1875.1104.camel@laptop>
	<1277725997.3561.6.camel@laptop>
	<20100628141927.GA9306@elte.hu>
	<1277736661.3561.110.camel@laptop>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have tested patch v3. All works fine for me.

I agree with Randy. The commentary should be fixed.

-- 
Ilya Loginov <isloginov@gmail.com>
