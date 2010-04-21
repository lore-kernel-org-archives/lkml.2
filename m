Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756598Ab0DUUwK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 16:52:10 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:32707 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756588Ab0DUUwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 16:52:08 -0400
Date: Wed, 21 Apr 2010 13:52:08 -0700
From: Dmitry Torokhov <dtor@vmware.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "pv-drivers@vmware.com" <pv-drivers@vmware.com>,
       Avi Kivity <avi@redhat.com>, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH v2] VMware Balloon driver
Message-ID: <20100421205208.GA4021@dtor-ws.eng.vmware.com>
References: <20100404215202.GA13020@dtor-ws.eng.vmware.com>
 <20100405142419.2c9bea3d.akpm@linux-foundation.org>
 <20100415210030.GA5359@dtor-ws.eng.vmware.com>
 <20100421195935.GA972@dtor-ws.eng.vmware.com>
 <20100421131836.8b31a8c6.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100421131836.8b31a8c6.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 21, 2010 at 01:18:36PM -0700, Andrew Morton wrote:
> On Wed, 21 Apr 2010 12:59:35 -0700
> Dmitry Torokhov <dtor@vmware.com> wrote:
> 
> > Do you see any issues with the driver?
> 
> Only my near-complete cluelessness on the whole topic.
> 
> > Will you be the one picking it
> > up and queueing for mainline?
> 
> Spose so.

Good. I don't suppose we have a chance making into .34? Being a
completely new driver and all...

Thanks,

Dmitry

