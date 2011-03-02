Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757881Ab1CBVSM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 16:18:12 -0500
Received: from cantor.suse.de ([195.135.220.2]:45200 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757613Ab1CBVSJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 16:18:09 -0500
Date: Wed, 2 Mar 2011 16:15:54 -0500
From: Greg KH <gregkh@suse.de>
To: Roel Van Nyen <roel.vannyen@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, acho@novell.com,
        error27@gmail.com
Subject: Re: [PATCH 1/2] Staging: keucr: Remove all the custom types from
 the driver except BOOLEAN
Message-ID: <20110302211554.GA24807@suse.de>
References: <1299099839-1416-1-git-send-email-roel.vannyen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299099839-1416-1-git-send-email-roel.vannyen@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 02, 2011 at 10:03:59PM +0100, Roel Van Nyen wrote:
> Remove all the custom types from this driver except the BOOLEAN,
> that will be handled by a separate patch.

I have a pending patch that is about to delete a lot of files in this
directory.  So care to redo this in a week or so after that one goes in
as this will conflict with it.

thanks,

greg k-h
