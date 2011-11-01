Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569Ab1KAKs2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 06:48:28 -0400
Received: from tuxonice.net ([96.126.116.212]:40807 "EHLO mail.tuxonice.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753057Ab1KAKs1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 06:48:27 -0400
X-Greylist: delayed 487 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Nov 2011 06:48:27 EDT
Message-ID: <4EAFCC8E.8070109@tuxonice.net>
Date: Tue, 01 Nov 2011 21:40:14 +1100
From: Nigel Cunningham <nigel@tuxonice.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.23) Gecko/20110922 Lightning/1.0b2 Thunderbird/3.1.15
MIME-Version: 1.0
To: Michael Leun <ml@newton.leun.net>
CC: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        richard -rw- weinberger <richard.weinberger@gmail.com>
Subject: Re: What about bugzilla.kernel.org / Bug 37142 / Tuxonice developer
 going to quit development
References: <20111101111420.1667f3aa@xenia.leun.net>
In-Reply-To: <20111101111420.1667f3aa@xenia.leun.net>
X-TagToolbar-Keys: D20111101214014893
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On 01/11/11 21:14, Michael Leun wrote:
> Is there any timeline for bringing bugzilla.kernel.org up again?
> 
> 
> I'm mainly asking because I was tracking 
> 
> Bug 37142 – [GM965/KMS/UXA] memory corruption on resume from hibernate
> 
> a memory corruption issue which is around for quite some time, see
> 
> http://thread.gmane.org/gmane.linux.kernel/1116939/focus=1117113
> 
> that was March 2011. I suspect this bug might be there since
> introduction of KMS.
> 
> My workaround since I noticed that bug was to use tuxonice for suspend
> to disk, what works perfectly (that in particular means without memory
> corruption), but unfortunately the current developer of tuxonice, Nigel
> Cunningham is going to stop development, see
> 
> http://lists.tuxonice.net/pipermail/tuxonice-users/2011-November/000945.html

I'm asking for input, not committing myself to stopping development
(yet). If there are good reasons to continue to maintain ToI, I'll
happily do that - I just have no idea at the moment how many people are
still saying "[u]swsusp doesn't work for me, TuxOnIce does."

Regards,

Nigel
-- 
Evolution (n): A hypothetical process whereby improbable
events occur with alarming frequency, order arises from chaos, and
no one is given credit.
