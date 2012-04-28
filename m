Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428Ab2D1XXv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 19:23:51 -0400
Received: from gate.crashing.org ([63.228.1.57]:46673 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753064Ab2D1XXu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 19:23:50 -0400
Message-ID: <1335655416.20866.17.camel@pasglop>
Subject: Re: Regression in 32-bit ppc kernel
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Andreas Schwab <schwab@linux-m68k.org>, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>
Date: Sun, 29 Apr 2012 09:23:36 +1000
In-Reply-To: <4F9C7A8E.1020009@lwfinger.net>
References: <4F973026.3020103@lwfinger.net>
	 <1335311621.15830.42.camel@pasglop> <4F976352.4060001@lwfinger.net>
	 <1335327081.21961.28.camel@pasglop> <4F98117C.7080309@lwfinger.net>
	 <1335390257.21961.53.camel@pasglop> <4F9ABD67.3060704@lwfinger.net>
	 <1335565573.20866.7.camel@pasglop> <4F9B3398.9060701@lwfinger.net>
	 <1335573757.20866.12.camel@pasglop> <4F9C3252.7020508@lwfinger.net>
	 <m2y5pflnqk.fsf@igel.home> <1335653288.20866.15.camel@pasglop>
	 <4F9C7A8E.1020009@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-04-28 at 18:17 -0500, Larry Finger wrote:
> Yes, good catch by Andreas. That change does fix the problem.
> 
> Ben - Do you want to fix the typos for open/not open with the same
> patch?
> 
Sure, if you're going to do a proper patch, by all means please fix
those too :-)

Does it fix all the occurrences of the problem for you ?

Cheers,
Ben.


