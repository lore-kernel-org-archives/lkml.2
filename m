Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757461Ab0IUWK7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 18:10:59 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:49030 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756351Ab0IUWK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 18:10:58 -0400
Date: Tue, 21 Sep 2010 15:10:33 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Uwe Bonnes <bon@elektron.ikp.physik.tu-darmstadt.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Any SYSRQ key to force mode switch to console mode when using
 KMS?
Message-Id: <20100921151033.80e61747.randy.dunlap@oracle.com>
In-Reply-To: <19601.1301.803816.92851@elektron.ikp.physik.tu-darmstadt.de>
References: <19601.1301.803816.92851@elektron.ikp.physik.tu-darmstadt.de>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Sep 2010 19:40:37 +0200 Uwe Bonnes wrote:

> Hello,
> 
> is there any SYSRQ key that forces the video system to console mode,
> especially when using KMS and allows to work on. 

sysrq-v help message says:

force-fb(V) = "Restore framebuffer console"

> Since going to KMS on a Thinkpad R50 with ATI Radeon RV250 via going from
> Opensuse-11.2 to Opensuse-11.3 I experience frequent situations where I am
> left with a black screen, with only ALT-SYSREQ-C switching the screen back
> on and hard reboot as only chance to escape that situation.
> 
> Situations that result in a black screen are:
> 
> * Going with the mouse over the NOSCRIPT buttom in firefox. Load goes up and
> screen goes black after some seconds. xorg.log ends with "Backtrace", but no
> backtrace output...
> 
> * Calling pm-hibernate on a system that has hibernated before. First
>   pm-hibernate/wake-up-per power buttom sequence is successfull.
> 
> Disabling KMS results in very slow "kaffeine" full screen output...
> 
> pm-hibernate and firefox/noscript worked pre-KMS on opensuse-11.2.
> 
> Some traces of other people hitting the NOSCRIPT xorg crash and others
> hitting the black unresponsive screen with KMS on RV250 are
> found on the net, but I didn't find a conclusive resolution.
> 
> Opensuse default kernel and the recent Opensuse 2.6.36-rc3 kernel-of-the day
> were tested with no difference
> 
> Thanks
> 
> PS: I only follow linux-kernel via gmane.org, so if you need fast feedback,
> please CC me. 

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
