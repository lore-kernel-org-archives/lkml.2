Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554Ab2F0ObA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 10:31:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11033 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753799Ab2F0Oa6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 10:30:58 -0400
Message-ID: <1340807456.1207.208.camel@bling.home>
Subject: Re: [PATCH v2 1/6] kvm: Pass kvm_irqfd to functions
From: Alex Williamson <alex.williamson@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: avi@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jan.kiszka@siemens.com
Date: Wed, 27 Jun 2012 08:30:56 -0600
In-Reply-To: <20120627093500.GF17507@redhat.com>
References: <20120627044758.23698.249.stgit@bling.home>
	 <20120627050858.23698.44118.stgit@bling.home>
	 <20120627093500.GF17507@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-27 at 12:35 +0300, Michael S. Tsirkin wrote:
> On Tue, Jun 26, 2012 at 11:09:04PM -0600, Alex Williamson wrote:
> > Prune this down to just the struct kvm_irqfd so we can avoid
> > changing function definition for every flag or field we use.
> > 
> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> 
> This is not needed anymore, right? We are not adding
> new fields.

Right, but I still prefer it.  Thanks,

Alex

