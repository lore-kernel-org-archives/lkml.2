Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761Ab0K2Tq1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 14:46:27 -0500
Received: from kroah.org ([198.145.64.141]:54575 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751074Ab0K2Tq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 14:46:26 -0500
Date: Mon, 29 Nov 2010 11:44:37 -0800
From: Greg KH <greg@kroah.com>
To: Marek Belisko <marek.belisko@open-nandra.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] Add misc device handling.
Message-ID: <20101129194437.GC14086@kroah.com>
References: <1290515373-16145-1-git-send-email-marek.belisko@open-nandra.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290515373-16145-1-git-send-email-marek.belisko@open-nandra.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 23, 2010 at 01:29:27PM +0100, Marek Belisko wrote:
> Following patch series use misc device instead of character device
> creation by kernel space (which is obvious obsolete and wrong).
> We add limitation for maximum 3 devices to be connected simultaneously.
> This interface is used only for testing and not influence basic device 
> functionality.

I've only applied the first patch in this series, please remove the
miscdevice stuff as others have pointed out.

thanks,

greg k-h
