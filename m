Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755168Ab0CXIEh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 04:04:37 -0400
Received: from senator.holtmann.net ([87.106.208.187]:43528 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754253Ab0CXIE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 04:04:29 -0400
Subject: Re: [PATCH 4/6] drivers:misc: sources for Init manager module
From: Marcel Holtmann <marcel@holtmann.org>
To: Greg KH <gregkh@suse.de>
Cc: "Savoy, Pavan" <pavan_savoy@ti.com>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20100324022358.GB4254@suse.de>
References: <1269292756-7469-1-git-send-email-pavan_savoy@ti.com>
	 <1269292756-7469-2-git-send-email-pavan_savoy@ti.com>
	 <1269292756-7469-3-git-send-email-pavan_savoy@ti.com>
	 <1269292756-7469-4-git-send-email-pavan_savoy@ti.com>
	 <19F8576C6E063C45BE387C64729E7394044DB828A2@dbde02.ent.ti.com>
	 <20100324022358.GB4254@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Mar 2010 01:04:20 -0700
Message-ID: <1269417860.11714.112.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

> > The source for this problem, was that I could not install line
> > discipline from kernel space.  i.e make N_TI_SHARED line discipline
> > the current ldisc from kernel space itself.
> 
> Are you sure?  I thought the bluetooth core did this already.  Have you
> looked at how that works?

I didn't have time to look at it at all so far. However I think this
should just go via a proper review process. And it might need some
architecture review first. It is clearly not a candidate for staging
since it is not really self-contained.

Regards

Marcel


