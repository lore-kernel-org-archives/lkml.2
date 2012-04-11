Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760626Ab2DKQRL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 12:17:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3042 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759825Ab2DKQRJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 12:17:09 -0400
Message-ID: <1334161024.3799.463.camel@bling.home>
Subject: Re: [PATCH v2 0/2] kvm: iommu unmap fixes
From: Alex Williamson <alex.williamson@redhat.com>
To: Greg KH <greg@kroah.com>
Cc: kvm@vger.kernel.org, stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        avi@redhat.com, jan.kiszka@siemens.com, mtosatti@redhat.com
Date: Wed, 11 Apr 2012 10:17:04 -0600
In-Reply-To: <20120411155957.GA31288@kroah.com>
References: <20120411154536.13227.10413.stgit@bling.home>
	 <20120411155957.GA31288@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-04-11 at 08:59 -0700, Greg KH wrote:
> On Wed, Apr 11, 2012 at 09:51:43AM -0600, Alex Williamson wrote:
> > This is a documentation change only from the previous version.
> > After discussing it, there is a potential page leak as noted
> > in the updated changelog for the first patch.  Thanks,
> 
> <formletter>
> 
> This is not the correct way to submit patches for inclusion in the
> stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
> for how to do this properly.
> 
> </formletter>

Sorry, Greg.  Thanks,

Alex

