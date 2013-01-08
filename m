Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755678Ab3AHWno (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 17:43:44 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:46328 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753456Ab3AHWnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 17:43:42 -0500
Subject: Re: [PATCH 1/5] x86,smp: move waiting on contended ticket lock out
 of line
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, aquini@redhat.com, walken@google.com,
        lwoodman@redhat.com, jeremy@goop.org,
        Jan Beulich <JBeulich@novell.com>, knoel@redhat.com,
        chegu_vinod@hp.com, raghavendra.kt@linux.vnet.ibm.com,
        mingo@redhat.com
In-Reply-To: <20130108173252.02a42e89@annuminas.surriel.com>
References: <20130108172632.1126898a@annuminas.surriel.com>
	 <20130108173252.02a42e89@annuminas.surriel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Jan 2013 14:43:39 -0800
Message-ID: <1357685019.18156.758.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-01-08 at 17:32 -0500, Rik van Riel wrote:
> Moving the wait loop for congested loops to its own function allows
> us to add things to that wait loop, without growing the size of the
> kernel text appreciably.
> 
> Signed-off-by: Rik van Riel <riel@redhat.com>
> Reviewed-by: Steven Rostedt <rostedt@goodmiss.org>
> Reviewed-by: Michel Lespinasse <walken@google.com>
> Reviewed-by: Rafael Aquini <aquini@redhat.com>
> ---
> v2: clean up the code a little, after Michel's suggestion 

Reviewed-by: Eric Dumazet <edumazet@google.com>


