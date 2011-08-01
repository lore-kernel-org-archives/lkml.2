Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754349Ab1HAX2y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 19:28:54 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:45937 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754327Ab1HAX2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 19:28:49 -0400
X-Sasl-enc: EjSHltvDhQ/+TkPkcU8Csv3OCin2zx0bBrcdF8HqMQGV 1312241327
Date: Mon, 1 Aug 2011 16:27:18 -0700
From: Greg KH <greg@kroah.com>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 2/4] drivers/base/devtmpfs.c: correct annotation of
 `setup_done'
Message-ID: <20110801232718.GA17808@kroah.com>
References: <1311268581-20405-1-git-send-email-lacombar@gmail.com>
 <1311268581-20405-2-git-send-email-lacombar@gmail.com>
 <CACqU3MVY6n5HXAqUXaOEjs_z=Q9G2PSGnCWHWkstZ0PZWjpoZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACqU3MVY6n5HXAqUXaOEjs_z=Q9G2PSGnCWHWkstZ0PZWjpoZA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 24, 2011 at 09:19:34PM -0400, Arnaud Lacombe wrote:
> Hi,
> 
> I saw that devtmpfs stuff went on through Al Viro's tree, maybe I
> should have Cc: him on this ?

No need, I'll get it.

thanks,

greg k-h
