Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120Ab0ERKDn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 06:03:43 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34548 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602Ab0ERKDm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 06:03:42 -0400
Subject: Re: [PATCH] x86: Export tsc related information in sysfs
From: Peter Zijlstra <peterz@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
       Venkatesh Pallipadi <venki@google.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, chris.mason@oracle.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <1274176698.5605.7358.camel@twins>
References: <1273887635-27610-1-git-send-email-venki@google.com>
	 <87tyq9mqrz.fsf@basil.nowhere.org>
	 <35aa841b-e151-424d-b1c1-0c03dbcae5cc@default>
	 <20100515121424.38f5b389@infradead.org>
	 <e07ac2f3-4a82-41d9-aa41-49a94435e7b7@default>
	 <20100515224305.17a04022@infradead.org>
	 <alpine.LFD.2.00.1005161113450.3199@localhost.localdomain>
	 <b7b4f345-944c-4cbc-b98a-700f915183b9@default alpine.LFD.2.00.1005161925480.3368@localhost.localdomain>
	 <5adf3fee-0f7b-4039-b13f-619640cc4b88@default>
	 <20100516220638.2baf315d@infradead.org>  <1274176698.5605.7358.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 18 May 2010 12:03:01 +0200
Message-ID: <1274176981.5605.7376.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-18 at 11:58 +0200, Peter Zijlstra wrote:
> On Sun, 2010-05-16 at 22:06 -0700, Arjan van de Ven wrote:
> > look we're not disabling ring 3 tsc. We could, but we don't.
> 
> Maybe we should.

We could then trap and emulate it with something sensible like clock
monotonic.

/me runs :-)
