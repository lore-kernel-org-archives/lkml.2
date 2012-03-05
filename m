Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757865Ab2CEXdq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 18:33:46 -0500
Received: from merlin.infradead.org ([205.233.59.134]:54586 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757245Ab2CEXdp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 18:33:45 -0500
Message-ID: <1330990413.11248.265.camel@twins>
Subject: Re: Inconsistent load average on tickless kernels
From: Peter Zijlstra <peterz@infradead.org>
To: Aman Gupta <aman@tmm1.net>
Cc: =?UTF-8?Q?Les=C5=82aw_Kope=C4=87?= <leslaw.kopec@nasza-klasa.pl>,
        linux-kernel@vger.kernel.org,
        Chase Douglas <chase.douglas@canonical.com>,
        Damien Wyart <damien.wyart@free.fr>, Kyle McMartin <kyle@redhat.com>,
        Venkatesh Pallipadi <venki@google.com>,
        Jonathan Nieder <jrnieder@gmail.com>,
        Doug Smythies <dsmythies@telus.net>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Tue, 06 Mar 2012 00:33:33 +0100
In-Reply-To: <1330990360.11248.264.camel@twins>
References: <CAK=uwuy80LaNdQ4P49i+bGUXFvxf1zB=oKqNBTdAyvFc+mOTyw@mail.gmail.com>
	 <4F465F6E.9070605@nasza-klasa.pl> <1330517195.11248.148.camel@twins>
	 <1330532667.11248.153.camel@twins> <1330534998.11248.158.camel@twins>
	 <4F551ABE.5080605@nasza-klasa.pl>
	 <CAK=uwuxvzGwes4ffy9EXVReG95U3HQaKmPPKgFnHzo_MwaO_NA@mail.gmail.com>
	 <1330989903.11248.261.camel@twins> <1330990360.11248.264.camel@twins>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-06 at 00:32 +0100, Peter Zijlstra wrote:
> +#ifdef X86_64

Ah see it wasn't, this patch wants s/\<X86_64\>/CONFIG_&/g done on it.

