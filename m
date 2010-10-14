Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753070Ab0JNBOh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 21:14:37 -0400
Received: from ozlabs.org ([203.10.76.45]:35077 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751187Ab0JNBOg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 21:14:36 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] futex: fix kernel-doc notation & typos
Date: Thu, 14 Oct 2010 11:44:32 +1030
User-Agent: KMail/1.13.5 (Linux/2.6.35-22-generic; KDE/4.5.1; i686; ; )
Cc: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
References: <20101013110234.89b06043.randy.dunlap@oracle.com>
In-Reply-To: <20101013110234.89b06043.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010141144.32470.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Oct 2010 04:32:34 am Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Convert futex_requeue() function parameters to use @name kernel-doc
> notation and add @fshared & @cmpval to prevent kernel-doc warnings.
> 
> Add @list to struct futex_q.
> 
> Fix a few typos.

Thanks,

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Isn't this a  job for the trivial patch monkey?
Rusty.
