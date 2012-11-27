Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000Ab2K0PYx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 10:24:53 -0500
Received: from hedwig.cmf.nrl.navy.mil ([134.207.12.162]:34104 "EHLO
	hedwig.cmf.nrl.navy.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753645Ab2K0PYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 10:24:52 -0500
Date: Tue, 27 Nov 2012 10:23:33 -0500
From: chas williams - CONTRACTOR <chas@cmf.nrl.navy.mil>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Krzysztof Mazur <krzysiek@podlesie.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH v3 8/7] pppoatm: fix missing wakeup in pppoatm_send()
Message-ID: <20121127102333.68ac3234@thirdoffive.cmf.nrl.navy.mil>
In-Reply-To: <1354022867.26346.334.camel@shinybook.infradead.org>
References: <201211112257.qABMvhP4021769@thirdoffive.cmf.nrl.navy.mil>
	<1354022867.26346.334.camel@shinybook.infradead.org>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Nov 2012 13:27:47 +0000
David Woodhouse <dwmw2@infradead.org> wrote:

> > i really would prefer not to use a strange name since it might confuse
> > larger group of people who are more familiar with the traditional meaning
> > of this function.  vcc_release() isnt exported so we could rename it if
> > things get too confusing.
> > 
> > i have to look at this a bit more but we might be able to use release_cb
> > to get rid of the null push to detach the underlying protocol.  that would
> > be somewhat nice.
> 
> In the meantime, should I resend this patch with the name 'release_cb'
> instead of 'unlock_cb'? I'll just put a comment in to make sure it isn't
> confused with vcc_release(), and if we need to change vcc_release()
> later we can.
> 

yes, but dont call it 8/7 since that doesnt make sense.
