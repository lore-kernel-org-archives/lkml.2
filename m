Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932733Ab2CZOxd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 10:53:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52056 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932602Ab2CZOxc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 10:53:32 -0400
Message-ID: <4F7082BD.9030107@zytor.com>
Date: Mon, 26 Mar 2012 07:52:45 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Jan Beulich <JBeulich@suse.com>
Subject: Re: [GIT PULL] x86, microcode fixes for 3.2
References: <20111128204311.GA2814@aftab> <20111202194658.GF15204@aftab> <20111205092612.GB29641@elte.hu> <20111205151016.GC7834@aftab> <4F6F719B.5020806@zytor.com> <20120326084810.GA31480@aftab>
In-Reply-To: <20120326084810.GA31480@aftab>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26/2012 01:48 AM, Borislav Petkov wrote:
> On Sun, Mar 25, 2012 at 12:27:23PM -0700, H. Peter Anvin wrote:
>> I keep wondering if we couldn't have the early-static trap handlers be
>> aware of exception tables, too; they wouldn't have to worry about
>> modules and so it would be reasonably easy.
> 
> Well, we talked about this recently and then we decided we needed the
> extable-sorting-at-build-time patches before we make those static trap
> handlers aware of extables. What happened to those patches, btw? See
> thread at http://marc.info/?l=linux-kernel&m=132196692827070
> 

Hm... I hope that didn't stall out because of me... the amount of
overload I have been under lately is a bit scary.

I was going to dredge out the perfect hash stuff that I had, but the
sorting stuff could be done without that.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

