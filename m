Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758494Ab0GHTDq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 15:03:46 -0400
Received: from kroah.org ([198.145.64.141]:49742 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758468Ab0GHTDo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 15:03:44 -0400
Date: Thu, 8 Jul 2010 12:03:28 -0700
From: Greg KH <greg@kroah.com>
To: =?utf-8?Q?Micha=C5=82?= Nazarewicz <m.nazarewicz@samsung.com>
Cc: linux-usb@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org,
       Dries Van Puymbroeck <Dries.VanPuymbroeck@dekimo.com>,
       stable <stable@kernel.org>
Subject: Re: [PATCHv2 1/2] USB: gadget: mass/file storage: set serial number
Message-ID: <20100708190328.GA6617@kroah.com>
References: <c73431dbedd41f94c5f471fb5e466943cee870c1.1277974263.git.m.nazarewicz@samsung.com>
 <624a27be8a9a4492976afaa8df78c07051cc6e25.1277987700.git.m.nazarewicz@samsung.com>
 <20100708183425.GB31823@kroah.com>
 <op.vfjga9ie7p4s8u@pikus>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <op.vfjga9ie7p4s8u@pikus>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 08, 2010 at 08:58:11PM +0200, Michał Nazarewicz wrote:
> >On Thu, Jul 01, 2010 at 03:42:19PM +0200, Michal Nazarewicz wrote:
> >>This commit adds iSerialNumber to all gadgets that use the Mass
> >>Storage Function.  It appears that Windows has problems when
> >>it is not set.
> >>
> >>Not to copy the same code all over again, a fsg_string_serial_fill()
> >>macro has been added to the storage_common.c file which is now also
> >>used in the File Storage Gadget.
> 
> On Thu, 08 Jul 2010 20:34:25 +0200, Greg KH <greg@kroah.com> wrote:
> >This patch conflicts with the patch in my tree:
> >	Subject: USB: Add a serial number parameter to g_file_storage module
> 
> Ah, there it is...  I remembered this patch but couldn't find it so assumed
> that it didn't make it to your tree after all.  But there it is...
> 
> >So, could you fix the above patch up to play nice with your change so
> >that I can accept it?
> 
> Sure thing.  If I won't post it within 2h I'll do that after the weekend
> (read Monday).

Sounds good.

Note, Monday I'll be somewhere in Europe so my email access might be a
bit limited for that week.

thanks,

greg k-h
