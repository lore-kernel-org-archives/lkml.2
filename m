Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932104Ab2F2POk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 11:14:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755434Ab2F2POj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 11:14:39 -0400
Message-ID: <1340982873.1207.335.camel@bling.home>
Subject: Re: [PATCH v2 1/6] kvm: Pass kvm_irqfd to functions
From: Alex Williamson <alex.williamson@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>, avi@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jan.kiszka@siemens.com
Date: Fri, 29 Jun 2012 09:14:33 -0600
In-Reply-To: <20120628083857.GD12447@redhat.com>
References: <20120627044758.23698.249.stgit@bling.home>
	 <20120627050858.23698.44118.stgit@bling.home>
	 <20120627162430.3477d0f6@BR9GNB5Z> <20120628083857.GD12447@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-28 at 11:38 +0300, Michael S. Tsirkin wrote:
> On Wed, Jun 27, 2012 at 04:24:30PM +0200, Cornelia Huck wrote:
> > On Tue, 26 Jun 2012 23:09:04 -0600
> > Alex Williamson <alex.williamson@redhat.com> wrote:
> > 
> > > Prune this down to just the struct kvm_irqfd so we can avoid
> > > changing function definition for every flag or field we use.
> > > 
> > > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > 
> > I'm currently trying to find a way to make irqfd workable for s390
> > which will likely include using a new field in kvm_irqfd, so I'd like
> > to have this change (and I also think it makes the code nicer to read).
> > So:
> > 
> > Acked-by: Cornelia Huck <cornelia.huck@de.ibm.com>
> 
> Unfortunately it looks like we are not sanitizing kvm_irqfd
> at all so we won't be able to use the padding :(
> We'll need a new ioctl instead.

I think you're jumping the gun on this decision.



