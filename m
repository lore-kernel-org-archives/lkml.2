Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658Ab0CWOAL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 10:00:11 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:34624 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753627Ab0CWOAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 10:00:06 -0400
Date: Tue, 23 Mar 2010 14:59:57 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>, James Morris <jmorris@namei.org>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kyle McMartin <kyle@mcmartin.ca>,
       Alexander Viro <viro@ftp.linux.org.uk>
Subject: Re: Upstream first policy
Message-ID: <20100323135956.GC1703@ucw.cz>
References: <alpine.LRH.2.00.1003080811220.30507@tundra.namei.org> <20100308094647.GA14268@elte.hu> <20100308173008.7ae389ab@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100308173008.7ae389ab@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Also, why was/(is?) AppArmor considered as a 'hostile competitor' 
> 
> I don't believe it was. It was perceived as a technical failure, and then
> the file system people shredded the bits the security folks didn't.

Unfortunately, in the meantime tomoyo was merged, which is basically
apparmor done wrong.

So I guess I owe an apology to apparmor people :-(.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
