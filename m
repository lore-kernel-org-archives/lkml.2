Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757575Ab1EYMeA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 08:34:00 -0400
Received: from nfitmail.nfit.au.dk ([130.225.31.129]:36493 "EHLO
	smtp.nfit.au.dk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757186Ab1EYMd7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 08:33:59 -0400
X-Greylist: delayed 451 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 May 2011 08:33:58 EDT
Date: Wed, 25 May 2011 14:26:18 +0200
From: Kasper Dupont <kasperd@nhnxn.25.may.2011.kasperd.net>
To: Valdis.Kletnieks@vt.edu
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: (Short?) merge window reminder
Message-ID: <20110525122618.GA14303@colin.search.kasperd.net>
References: <BANLkTi=PLuZhx1=rCfOtg=aOTuC1UbuPYg@mail.gmail.com> <20110523192056.GC23629@elte.hu> <BANLkTikdgM+kSvaEYuQkgCYJZELnvwfetg@mail.gmail.com> <20110523231721.GM10009@thunk.org> <4DDAEC68.30803@zytor.com> <BANLkTikGfVSAMY2a2yiXaNpvBVvF8YdMEA@mail.gmail.com> <6043.1306285994@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <6043.1306285994@localhost>
User-Agent: Mutt/1.4.2.3i
X-NFIT-ADSL: 2
X-NFIT-RelayAddr: 130.225.16.160
X-NFIT-MX: True
X-Sim: 5b170ca98771493eef230891d2a96533cd035a237320acf425082ff4ee90feef 1158
X-NFIT-Solido-Score: 3.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/05/11 21.13, Valdis.Kletnieks@vt.edu wrote:
> Well, if we're looking at ELF-sized ABI changes, how about 3.0 be the
> release where we re-sync the syscall numbers on all the archs? ;)

If you want to do that I think the best way to do it is to
have both the old and the new numbers co-exist through the
3.x series and the old ones go away in 4.0.

You'd first have to find the highest number currently
assigned and then add a bit of safety margin to decide on
a starting point for the new numbers.

Should architecture dependent system calls be assigned
from a separate interval where they could overlap between
architectures? Or should they be assigned from the same
sequence as other calls and return -ENOSYS on other
architectures than the one they were targeted for?

Or was it all a joke, and you don't actually want that
cleanup to happen because of too much breakage?

-- 
Kasper Dupont -- Rigtige mænd skriver deres egne backupprogrammer
#define _(_)"d.%.4s%."_"2s" /* This is my email address */
char*_="@2kaspner"_()"%03"_("4s%.")"t\n";printf(_+11,_+6,_,11,_+2,_+7,_+6);
