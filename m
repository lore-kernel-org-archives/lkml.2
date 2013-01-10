Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389Ab3AJRlI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 12:41:08 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:37681 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690Ab3AJRlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 12:41:06 -0500
Date: Thu, 10 Jan 2013 23:08:41 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, aquini@redhat.com, walken@google.com,
        eric.dumazet@gmail.com, lwoodman@redhat.com, jeremy@goop.org,
        Jan Beulich <JBeulich@novell.com>, knoel@redhat.com,
        chegu_vinod@hp.com, raghavendra.kt@linux.vnet.ibm.com,
        mingo@redhat.com
Subject: Re: [PATCH 1/5] x86,smp: move waiting on contended ticket lock out
 of line
Message-ID: <20130110173840.GB31549@linux.vnet.ibm.com>
Reply-To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
References: <20130108172632.1126898a@annuminas.surriel.com>
 <20130108173252.02a42e89@annuminas.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20130108173252.02a42e89@annuminas.surriel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011017-5406-0000-0000-0000040D2DAC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rik van Riel <riel@redhat.com> [2013-01-08 17:32:52]:

> Moving the wait loop for congested loops to its own function allows
> us to add things to that wait loop, without growing the size of the
> kernel text appreciably.
> 
> Signed-off-by: Rik van Riel <riel@redhat.com>
> Reviewed-by: Steven Rostedt <rostedt@goodmiss.org>
> Reviewed-by: Michel Lespinasse <walken@google.com>
> Reviewed-by: Rafael Aquini <aquini@redhat.com>

Reviewed-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>

