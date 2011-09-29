Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337Ab1I2Tu2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 15:50:28 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:53030 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753614Ab1I2Tu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 15:50:26 -0400
Message-ID: <4E84CC00.8090702@xenotime.net>
Date: Thu, 29 Sep 2011 12:50:24 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110907 SUSE/3.1.14 Thunderbird/3.1.14
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: linux-next: Tree for Sept 29 (kvm)
References: <20110929165730.661cf28c9bb27b8a85432cd2@canb.auug.org.au>
In-Reply-To: <20110929165730.661cf28c9bb27b8a85432cd2@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/11 23:57, Stephen Rothwell wrote:
> Hi all,
> 
> The linux-next tree is now available from
> git://github.com/sfrothwell/linux-next.git as a temporary measure while
> the kernel.org servers are unavailable.


kvm build on i386 says:

ERROR: "__udivdi3" [arch/x86/kvm/kvm.ko] undefined!

which is used in somewhere in start_apic_timer()  (probably the divide :).


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
