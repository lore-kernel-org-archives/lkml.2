Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577Ab2DPOZE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 10:25:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:58948 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753945Ab2DPOZC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 10:25:02 -0400
Message-ID: <1334586287.28150.54.camel@twins>
Subject: Re: kvm: RCU warning in async pf
From: Peter Zijlstra <peterz@infradead.org>
To: Gleb Natapov <gleb@redhat.com>
Cc: Sasha Levin <levinsasha928@gmail.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        kvm <kvm@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
Date: Mon, 16 Apr 2012 16:24:47 +0200
In-Reply-To: <20120416141735.GA18613@redhat.com>
References: <1333414472.11455.7.camel@lappy>
	 <20120403105226.GF14939@redhat.com> <20120404123033.GD11918@redhat.com>
	 <1334396693.2528.45.camel@twins> <20120416102855.GP11918@redhat.com>
	 <20120416125848.GT11918@redhat.com> <1334581548.28150.40.camel@twins>
	 <20120416130806.GV11918@redhat.com> <1334582281.28150.41.camel@twins>
	 <1334582840.28150.43.camel@twins> <20120416141735.GA18613@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-16 at 17:17 +0300, Gleb Natapov wrote:
> Should I resend the patch with removal of exit_idle() call or it will
> be removed by a patch that removes exit_idle() completely later?
> 
I think we can do the latter, once we decided what to do with that stuff
we can clean it up/remove it whole sale.
