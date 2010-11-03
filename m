Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986Ab0KCLiW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 07:38:22 -0400
Received: from kroah.org ([198.145.64.141]:50353 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752717Ab0KCLiU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 07:38:20 -0400
Date: Wed, 3 Nov 2010 04:36:03 -0700
From: Greg KH <greg@kroah.com>
To: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Brandon Philips <brandon@ifup.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 05/10] staging: hv: Convert camel cased functions in
	hv.c to lower cases
Message-ID: <20101103113603.GA13276@kroah.com>
References: <1288644369-12958-1-git-send-email-haiyangz@linuxonhyperv.com> <1288644369-12958-2-git-send-email-haiyangz@linuxonhyperv.com> <1288644369-12958-3-git-send-email-haiyangz@linuxonhyperv.com> <1288644369-12958-4-git-send-email-haiyangz@linuxonhyperv.com> <1288644369-12958-5-git-send-email-haiyangz@linuxonhyperv.com> <20101102170406.GA4557@jenkins.home.ifup.org> <1FB5E1D5CA062146B38059374562DF728BA55BD7@TK5EX14MBXC126.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1FB5E1D5CA062146B38059374562DF728BA55BD7@TK5EX14MBXC126.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 02, 2010 at 09:06:56PM +0000, Haiyang Zhang wrote:
> > From: Brandon Philips [mailto:brandon@ifup.org]
> > Sent: Tuesday, November 02, 2010 1:04 PM
> > > -static int HvQueryHypervisorInfo(void)
> > > +static int hvquery_hypervisor_info(void)
> > > -static u64 HvDoHypercall(u64 control, void *input, void *output)
> > > +static u64 hvdo_hypercall(u64 control, void *input, void *output)
> > 
> > Should these be hv_do_hypercall and hv_query_hypervisor? That seems to
> > be the style in the rest of the patch:
> 
> I didn't insert underscore between every word, for example, it's not
> added between two short words.

But you should.  Remember, be consistent.

Care to redo these again?

thanks,

greg k-h
