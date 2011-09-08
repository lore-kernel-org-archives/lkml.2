Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932236Ab1IHH36 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 03:29:58 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50734 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758097Ab1IHH35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 03:29:57 -0400
Date: Thu, 8 Sep 2011 15:29:48 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: "Nallasellan, Singaravelan" <singaravelan.nallasellan@intel.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Player Thread is not woken after period elapsed
Message-ID: <20110908072948.GB11124@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <3CA6C6D9F70D314CA34352990B57DA1507C420F147@bgsmsx502.gar.corp.intel.com>
 <20110905105253.2787b91f@infradead.org>
 <3CA6C6D9F70D314CA34352990B57DA1507C420F15C@bgsmsx502.gar.corp.intel.com>
 <20110905112225.72b46ac9@infradead.org>
 <3CA6C6D9F70D314CA34352990B57DA1507C4275D58@bgsmsx502.gar.corp.intel.com>
 <20110906200614.57a99d3d@infradead.org>
 <3CA6C6D9F70D314CA34352990B57DA1507C42767FA@bgsmsx502.gar.corp.intel.com>
 <20110908021327.GA8890@zhy>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110908021327.GA8890@zhy>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 08, 2011 at 10:13:27AM +0800, Yong Zhang wrote:
> On Wed, Sep 07, 2011 at 05:32:10PM +0530, Nallasellan, Singaravelan wrote:
> > 
> > > 
> > > > >
> > > > > Please always test bugs like this with a recent kernel. 2.6.35 is
> > > > > pretty much 6 versions (and 18 months) behind and at that point you
> > > > > really have to test with something newer first before asking others
> > > > > to help you and spend their time on your problem.
> > > > >
> > > > Unfortunately, I am stuck with that version as the product that I work
> > > > on is on that version.
> > > 
> > > and that is everyone elses problem ... how?
> > > 
> > > if you can't be bothered to try at least a recent kernel, why would anyone else
> > > be bothered to help you on their own time?????
> > > 
> > I completely agree with you. Sorry for the inconvenience. But I have no choice. 
> > Further investigation of this issue shows that the thread is in running state and it is not scheduled. I am not sure how I will go about debugging this issue. Any pointer would help. 
> 
> Could you confirm if [commit f26f9af Sched: fix skip_clock_update optimization]
> residents in your kernel?

And commit da7a735e51f9622eb3e1672594d4a41da01d7e4f
http://marc.info/?l=linux-kernel&m=129527509622696&w=2

Thanks,
Yong
