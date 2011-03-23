Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932550Ab1CWNyS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 09:54:18 -0400
Received: from cantor.suse.de ([195.135.220.2]:35133 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932467Ab1CWNyQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 09:54:16 -0400
Date: Wed, 23 Mar 2011 06:51:26 -0700
From: Greg KH <gregkh@suse.de>
To: "Weil, Oren jer" <oren.jer.weil@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        "david@woodhou.se" <david@woodhou.se>
Subject: Re: [PATCH 0/7] char/mei: Intel MEI Driver
Message-ID: <20110323135126.GB16769@suse.de>
References: <1300791092-14319-1-git-send-email-oren.jer.weil@intel.com>
 <201103221750.52118.arnd@arndb.de>
 <F28B59AD52D84B479DCA469824475335065A6AC81D@hasmsx503.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F28B59AD52D84B479DCA469824475335065A6AC81D@hasmsx503.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 09:20:20AM +0200, Weil, Oren jer wrote:
> >I suppose one of the important things to do here is integrate the watchdog
> >part into the common watchdog infrastructure in drivers/watchdog. Maybe
> >this driver can export a simple interface to another module that implements
> >the watchdog device?
> 
> Yes, this is one the ideas the Alan suggested, 
> we are thinking about this direction in the future.

What's keeping you from doing this now?

thanks,

greg k-h
