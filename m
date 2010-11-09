Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518Ab0KIH6s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 02:58:48 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:50451 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812Ab0KIH6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 02:58:48 -0500
Subject: Re: PROBLEM: brcm80211 unable to survive suspend/resume cycle
From: Jon Masters <jonathan@jonmasters.org>
To: Greg KH <greg@kroah.com>
Cc: devel <devel@linuxdriverproject.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20101109032455.GA31048@kroah.com>
References: <1289272437.3916.440.camel@constitution.bos.jonmasters.org>
	 <20101109032455.GA31048@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Organization: World Organi[sz]ation of Broken Dreams
Date: Tue, 09 Nov 2010 02:58:56 -0500
Message-ID: <1289289536.3916.465.camel@constitution.bos.jonmasters.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-08 at 19:24 -0800, Greg KH wrote:
> On Mon, Nov 08, 2010 at 10:13:57PM -0500, Jon Masters wrote:
> > Folks,
> > 
> > I reported this before, but let me open up a new thread for this now
> > that this driver has landed in 2.6.37-rc1 and been out for a while. I am
> > able to use this driver (more or less) for daily use on my netbook, but
> > it is unable survive a suspend/resume cycle without being unloaded and
> > then reloaded again on resume. That actually seems to work quite well.
> > 
> > I believe the problem is firmware related:
> 
> <snip>
> 
> Did you copy the authors/developers on this bug report?
> 
> Please do that...

I forwarded the mail to Brett right after I sent it because I had missed
them the original CC. Apologies for that. I didn't think it necessary to
send a followup but appreciate your mail - anyway, I think they got it.

Jon.


