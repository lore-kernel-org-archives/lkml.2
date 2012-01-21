Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751701Ab2AUM4o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 07:56:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43477 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345Ab2AUM4m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 07:56:42 -0500
Date: Sat, 21 Jan 2012 07:51:53 -0500
From: Greg KH <gregkh@suse.de>
To: =?iso-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Cc: Chris Ball <cjb@laptop.org>, linux-mmc@vger.kernel.org,
        devel@driverdev.osuosl.org, techeng <dzshen@gmail.com>, clyu@citiz.net,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add Winbond WB528SD Secure Digital (SD) card reader
 driver
Message-ID: <20120121125153.GB18829@suse.de>
References: <4F1A98F5.3080402@freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4F1A98F5.3080402@freemail.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 21, 2012 at 11:52:37AM +0100, Németh Márton wrote:
> From: Márton Németh <nm127@freemail.hu>
> 
> This driver version of Winbond WB528SD can detect mechanical card
> presence only. The information is provided through sysfs.

How is it provided through sysfs?  Is this done in a standard way?  If
not, why not?

Why is this driver submitted to the staging tree?  What is keeping it
from going into the "real" portion of the kernel for other card readers?

We need a TODO file for what is needed to get it moved out of staging.

Oh, and it needs to do a bit more than just detect a card to be useful,
right?  How about read/write to it?

thanks,

greg k-h
