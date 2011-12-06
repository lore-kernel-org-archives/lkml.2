Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752333Ab1LFR4x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 12:56:53 -0500
Received: from casper.infradead.org ([85.118.1.10]:54606 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226Ab1LFR4v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 12:56:51 -0500
Message-ID: <1323194173.32012.83.camel@twins>
Subject: Re: [tip:core/locking] lockdep, rtmutex, bug: Show taint flags on
 error
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ben Hutchings <ben@decadent.org.uk>, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
        linux-tip-commits@vger.kernel.org
Date: Tue, 06 Dec 2011 18:56:13 +0100
In-Reply-To: <20111206175558.3215907c@lxorguk.ukuu.org.uk>
References: <1319773015.6759.30.camel@deadeye>
	 <tip-fbdc4b9a6c29befbcca65e5366e5aaf2abb7a013@git.kernel.org>
	 <1323185640.7454.269.camel@deadeye> <1323193731.32012.81.camel@twins>
	 <20111206175558.3215907c@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-12-06 at 17:55 +0000, Alan Cox wrote:
> On Tue, 06 Dec 2011 18:48:51 +0100
> Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > On Tue, 2011-12-06 at 15:34 +0000, Ben Hutchings wrote:
> > > If you disagree with a patch, do not silently drop parts of it.  I
> > > demand that you remove my 'Signed-off-by' as this is not the change I
> > > submitted. 
> > 
> > The easy solution is that I never take patches from you again, ever.
> > Consider that done. I'll let Ingo see if he can remove your SOB.
> 
> In which case you are presumably ceasing to be a maintainer for that
> code ? Your statement above appears to be inconsistent with the rôle of a
> maintainer.

There's plenty people who have various other people blacklisted in the
procmail. My blacklist is shorter than some, Merkey isn't actually on it
for instance.


