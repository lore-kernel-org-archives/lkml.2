Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269Ab0DEDoR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Apr 2010 23:44:17 -0400
Received: from mga06.intel.com ([134.134.136.21]:5968 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754029Ab0DEDoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Apr 2010 23:44:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,364,1267430400"; 
   d="scan'208";a="610207366"
Message-ID: <4BB95C85.80205@linux.intel.com>
Date: Sun, 04 Apr 2010 20:44:05 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Dominik Brodowski <linux@dominikbrodowski.net>,
       Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, Dmitry Torokhov <dtor@mail.ru>
Subject: Re: A few questions and issues with dynticks, NOHZ and powertop
References: <20100403223328.GA4507@comet.dominikbrodowski.net> <Pine.LNX.4.44L0.1004041110010.2750-100000@netrider.rowland.org> <20100404163924.GA18428@comet.dominikbrodowski.net> <20100404204725.GC2644@linux.vnet.ibm.com> <20100404233702.GA24102@linux.vnet.ibm.com>
In-Reply-To: <20100404233702.GA24102@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> And you did mention offlining some CPUs above.  The folloiwng patch
> (from Lai Jiangshan) is needed to handle this case.

btw on x86... don't offline CPUs if you want to save power.. it doesn't.
(at least not during idle.. and when you're busy it might save power, but it won't save you energy normally)
