Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757875Ab2JQUo3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 16:44:29 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:52279 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755420Ab2JQUo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 16:44:28 -0400
X-Sasl-enc: HzOZLALMOm82OTpLexgTZkPLeLivuBx9Bixd8BKiO8HP 1350506667
Date: Wed, 17 Oct 2012 13:44:26 -0700
From: Greg Kroah-Hartman <greg@kroah.com>
To: Borislav Petkov <bp@amd64.org>
Cc: Tony Luck <tony.luck@intel.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 1/5] drivers/base: Add a DEVICE_BOOL_ATTR macro
Message-ID: <20121017204426.GA22994@kroah.com>
References: <1350472435-29307-1-git-send-email-bp@amd64.org>
 <1350472435-29307-2-git-send-email-bp@amd64.org>
 <20121017190300.GB25996@kroah.com>
 <20121017201018.GC32230@aftab.osrc.amd.com>
 <20121017202900.GA30907@kroah.com>
 <20121017203612.GE32230@aftab.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121017203612.GE32230@aftab.osrc.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2012 at 10:36:12PM +0200, Borislav Petkov wrote:
> On Wed, Oct 17, 2012 at 01:29:00PM -0700, Greg Kroah-Hartman wrote:
> > Take the function already from the module code, it should be reusable,
> > if not, it would be a good idea to make it so.
> 
> Function from module code? Do you mean param_get_bool/param_set_bool in
> kernel/params.c?

Yes, that's what I was thinking of, but I guess it just comes down to a
call to strtobool(), which is what you need here.

greg k-h
