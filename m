Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934419Ab2FHRLn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 13:11:43 -0400
Received: from www.hansjkoch.de ([178.63.77.200]:49371 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933890Ab2FHRLk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 13:11:40 -0400
Date: Fri, 8 Jun 2012 19:11:28 +0200
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: Dominic Eschweiler <eschweiler@fias.uni-frankfurt.de>
Cc: "Hans J. Koch" <hjk@hansjkoch.de>, "Michael S. Tsirkin" <mst@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uio_pci_generic does not export memory resources
Message-ID: <20120608171128.GF9705@local>
References: <1339156616.3870.9.camel@blech>
 <20120608130351.GB1964@redhat.com>
 <1339165738.3870.18.camel@blech>
 <20120608151843.GA9705@local>
 <1339170312.26423.6.camel@tesla>
 <20120608155728.GB9705@local>
 <1339172599.26423.13.camel@tesla>
 <20120608163728.GD9705@local>
 <1339175266.26423.20.camel@tesla>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339175266.26423.20.camel@tesla>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2012 at 07:07:46PM +0200, Dominic Eschweiler wrote:
> Am Freitag, den 08.06.2012, 18:37 +0200 schrieb Hans J. Koch:
> > It does, the documentation is just not very explicit when it comes to
> > memory mapping. 
> 
> OK, quoting the other mail:
> 
> Am Freitag, den 08.06.2012, 19:39 +0300 schrieb Michael S. Tsirkin:
> 
> > Documentation says this:
> > 
> >         Userspace driver can use pci sysfs interface, or the
> >         libpci libray that wraps it, to talk to the device and to
> >         re-enable interrupts by writing to the command register. 
> 
> I think should ditch the discussion about the patch and I'm going to
> revise the documentation? I read this part a couple of times and allways
> thought the "sysfs interface" refers to the UIO sysfs entry. 

Ah OK, it's easy to misunderstand that.

> 
> Therefore, would it be OK if I send a patch for the documentation next
> week?

Sure, that would be great!

Thanks,
Hans
