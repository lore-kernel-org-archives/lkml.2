Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751902Ab1JOInT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 04:43:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:37917 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054Ab1JOInS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 04:43:18 -0400
Subject: Re: [PATCH RFC V4 10/10] jump-label: initialize jump-label
 subsystem much earlier
From: Peter Zijlstra <peterz@infradead.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        "David S. Miller" <davem@davemloft.net>,
        David Daney <david.daney@cavium.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Jan Glauber <jang@linux.vnet.ibm.com>, Jason Baron <jbaron@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Date: Sat, 15 Oct 2011 10:42:38 +0200
In-Reply-To: <4E98AEDD.4010503@goop.org>
References: <cover.1318464169.git.jeremy.fitzhardinge@citrix.com>
	  <c133180533d7e520bb1e818e987117811a666fbc.1318464413.git.jeremy.fitzhardinge@citrix.com>
	 <1318502628.24856.10.camel@twins> <4E98AEDD.4010503@goop.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1318668158.6594.0.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-10-14 at 14:51 -0700, Jeremy Fitzhardinge wrote:
> How about this?  Proper comment and much earlier init.

Looks good to me, thanks!
