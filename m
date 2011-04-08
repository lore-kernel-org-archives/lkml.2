Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128Ab1DHGXo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 02:23:44 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:57956 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752624Ab1DHGXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 02:23:43 -0400
Date: Fri, 8 Apr 2011 08:22:25 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Len Brown <lenb@kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>,
        x86@kernel.org, Jiri Kosina <jkosina@suse.cz>, stable@kernel.org
Subject: Re: [PATCH 03/18] x86 idle APM: deprecate CONFIG_APM_CPU_IDLE
Message-ID: <20110408062225.GA1596@ucw.cz>
References: <alpine.LFD.2.02.1104010020280.2797@x980>
 <1301725380-10579-1-git-send-email-lenb@kernel.org>
 <392e1ffeeaefd448f69d45041fe4406fbd197852.1301724243.git.len.brown@intel.com>
 <20110402122810.1371afa8@lxorguk.ukuu.org.uk>
 <alpine.LFD.2.02.1104021427040.18682@x980>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1104021427040.18682@x980>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2011-04-02 14:28:31, Len Brown wrote:
> > Give it a year, it doesn't cause any complexities I can see.
> 
> I'd rather not create a new an APM cpuilde driver,
> since there is nobody volunteering to test it.
> If you have the time and the hardware, please speak up.

I'm willing to test is, as is Jiri Kosina AFAICT.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
