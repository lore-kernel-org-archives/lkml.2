Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932506Ab2GKNE3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 09:04:29 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48139 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932486Ab2GKNEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 09:04:25 -0400
Date: Wed, 11 Jul 2012 06:04:20 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc: Gustavo Padovan <gustavo@padovan.org>, linux-bluetooth@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>,
        "open list:USB SUBSYSTEM" <linux-usb@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] USB: add USB_VENDOR_AND_INTERFACE_INFO() macro
Message-ID: <20120711130420.GA6892@kroah.com>
References: <1341957063-11989-1-git-send-email-gustavo@padovan.org>
 <20120710220108.GA28387@kroah.com>
 <877guahext.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <877guahext.fsf@nemi.mork.no>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2012 at 10:36:46AM +0200, Bjørn Mork wrote:
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
> > On Tue, Jul 10, 2012 at 06:51:03PM -0300, Gustavo Padovan wrote:
> >
> >> { USB_VENDOR_AND_INTERFACE_INFO(0x0a5c, 0xff, 0x01, 0x01) }
> >
> > Two entries in the cdc_wdm driver can also be converted to use this
> > interface.  Do you want to send a patch doing that, or do you want me to
> > do it?
> 
> Only if you decide to take this change in 3.4 and 3.5.  Those entries
> are gone in 3.6.

Ah, the joys of looking at the wrong branch in git :)

Nevermind...

greg k-h
