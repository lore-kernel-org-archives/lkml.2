Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757415Ab1FFPKP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 11:10:15 -0400
Received: from cantor.suse.de ([195.135.220.2]:47503 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756877Ab1FFPKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 11:10:09 -0400
Date: Mon, 6 Jun 2011 08:06:55 -0700
From: Greg KH <gregkh@suse.de>
To: "Stefan (metze) Metzmacher" <metze@samba.org>
Cc: David Miller <davem@davemloft.net>, oliver@neukum.name,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usbnet/cdc_ncm: add missing .reset_resume hook
Message-ID: <20110606150655.GB3732@suse.de>
References: <2AC7D4AD8BA1C640B4C60C61C8E520153E3C07E568@EXDCVYMBSTM006.EQ1STM.local>
 <1306929701-22861-1-git-send-email-metze@samba.org>
 <1306929701-22861-2-git-send-email-metze@samba.org>
 <20110601.211142.557328157396419857.davem@davemloft.net>
 <4DECC6B4.5020108@samba.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DECC6B4.5020108@samba.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 06, 2011 at 02:23:16PM +0200, Stefan (metze) Metzmacher wrote:
> Hi David,
> 
> > From: Stefan Metzmacher <metze@samba.org>
> > Date: Wed,  1 Jun 2011 14:01:41 +0200
> > 
> >> This avoids messages like this after suspend:
> >>
> >>    cdc_ncm 2-1.4:1.6: no reset_resume for driver cdc_ncm?
> >>    cdc_ncm 2-1.4:1.7: no reset_resume for driver cdc_ncm?
> >>    cdc_ncm 2-1.4:1.6: usb0: unregister 'cdc_ncm' usb-0000:00:1d.0-1.4, CDC NCM
> >>
> >> This is important for the Ericsson F5521gw GSM/UMTS modem.
> >> Otherwise modemmanager looses the fact that the cdc_ncm and cdc_acm devices
> >> belong together.
> >>
> >> The cdc_ether module does the same.
> >>
> >> Signed-off-by: Stefan Metzmacher <metze@samba.org>
> > 
> > Applied and queued up for -stable, thanks.
> 
> It seems to be part of 3.0-rc2, but I'm not seeing it in any stable tree
> yet...
> 
> When can I expect it in stable trees like 2.6.38.y?

The .38.y tree is closed and will not have new releases, so you will
never see it there, sorry.

greg k-h
