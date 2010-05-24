Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757210Ab0EXPz0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 11:55:26 -0400
Received: from relay3.sgi.com ([192.48.152.1]:52884 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753011Ab0EXPzZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 11:55:25 -0400
Date: Mon, 24 May 2010 10:55:06 -0500
From: Russ Anderson <rja@sgi.com>
To: Tony Luck <tony.luck@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Andi Kleen <andi@firstfloor.org>, Borislav Petkov <bp@amd64.org>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       "Young, Brent" <brent.young@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Matt Domsch <Matt_Domsch@dell.com>,
       Doug Thompson <dougthompson@xmission.com>,
       Joe Perches <joe@perches.com>, Ingo Molnar <mingo@elte.hu>,
       "bluesmoke-devel@lists.sourceforge.net" 
	<bluesmoke-devel@lists.sourceforge.net>,
       Linux Edac Mailing List <linux-edac@vger.kernel.org>, rja@sgi.com
Subject: Re: Hardware Error Kernel Mini-Summit
Message-ID: <20100524155506.GA7145@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
References: <4BF2392A.9040409@jp.fujitsu.com> <4BF2C3D1.10009@redhat.com> <1274204560.17703.82.camel@Joe-Laptop.home> <20100518185305.GA23921@elte.hu> <987664A83D2D224EAE907B061CE93D53C61D1C57@orsmsx505.amr.corp.intel.com> <20100518191802.GG25224@aftab> <m1k4r0c0y7.fsf@fess.ebiederm.org> <20100518222832.GJ22675@basil.fritz.box> <m1wrv0zo9q.fsf@fess.ebiederm.org> <AANLkTilxFZygP7YJybluPxtdxVGqWeqR4g7CRr8EEocW@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTilxFZygP7YJybluPxtdxVGqWeqR4g7CRr8EEocW@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 19, 2010 at 10:30:17AM -0700, Tony Luck wrote:
> 
> We are still in the dark ages for memory errors where the OS
> is expected to look at all the errors and figure out whether they
> represent any kind of meaningful pattern that requires some
> action to replace h/w components.

ia64 is good at detecting & recovering from memory uncorrectable
errors.  x86 is significantly behind, due to historically not
being able to recover from uncorrectable memory errors.  

ia64 had the Intel defined MCA Spec which defined the interaction
between SAL and the kernel.  x86 does not have a similar well
defined way of how errors should be handled.  It would be 
good to agree on how the errors should be handled.

> -Tony

-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
