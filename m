Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755097Ab0D1PyU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 11:54:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41595 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755052Ab0D1PyS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 11:54:18 -0400
Date: Wed, 28 Apr 2010 08:53:35 -0700
From: Greg KH <gregkh@suse.de>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Robert Hancock <hancockrwd@gmail.com>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: INFO: umount blocked for more than 120 seconds
Message-ID: <20100428155335.GA12624@suse.de>
References: <20100427094614.GA3345@swordfish.minsk.epam.com>
 <Pine.LNX.4.44L0.1004271457160.1850-100000@iolanthe.rowland.org>
 <20100428080027.GB30496@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100428080027.GB30496@swordfish.minsk.epam.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 28, 2010 at 11:00:27AM +0300, Sergey Senozhatsky wrote:
> On (04/27/10 15:07), Alan Stern wrote:
> > Robert was right.  Your usbmon log covers only the last 40 seconds of
> > data transfer and showed a little over 15 MB being sent, so it seems
> > likely that the entire 246 MB transfer would require more than 10
> > minutes.
> > 
> 
> Thanks.
> 
> > You can test this easily enough by simply waiting for 12 minutes or so
> > before issuing the "umount" command.
> > 
> So, bug entry is invalid. Right?

Yes, I think so.

thanks,

greg k-h
