Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758840Ab0D3Rjc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:39:32 -0400
Received: from kroah.org ([198.145.64.141]:37864 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756257Ab0D3Rid (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:38:33 -0400
Date: Thu, 29 Apr 2010 18:41:59 -0700
From: Greg KH <greg@kroah.com>
To: Yoichi Yuasa <yuasa@linux-mips.org>
Cc: Naren Sankar <nsankar@broadcom.com>, Jarod Wilson <jarod@wilsonet.com>,
       Scott Davilla <davilla@4pi.com>, Manu Abraham <abraham.manu@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/11] staging: crystalhd: remove unused bc_dts_types.h
Message-ID: <20100430014159.GA10862@kroah.com>
References: <20100425221851.223dc284.yuasa@linux-mips.org> <20100429191043.GF21799@kroah.com> <20100430094036.2dc10a8f.yuasa@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100430094036.2dc10a8f.yuasa@linux-mips.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 30, 2010 at 09:40:36AM +0900, Yoichi Yuasa wrote:
> On Thu, 29 Apr 2010 12:10:43 -0700
> Greg KH <greg@kroah.com> wrote:
> 
> > On Sun, Apr 25, 2010 at 10:18:51PM +0900, Yoichi Yuasa wrote:
> > > Signed-off-by: Yoichi Yuasa <yuasa@linux-mips.org>
> > > ---
> > >  drivers/staging/crystalhd/bc_dts_defs.h  |    2 -
> > >  drivers/staging/crystalhd/bc_dts_types.h |  121 ------------------------------
> > 
> > Wait, all crystalhd patches should go through Ralf's tree, can you send
> > these to him instead?
> 
> These patches are not related to MIPS.
> I just sent to you.

I understand, but for this driver, Ralf takes the changes through his
tree for a variety of different reasons.  So please, resend them to him.

thanks,

greg k-h
