Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751161Ab1K0JNv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 04:13:51 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:39097 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750789Ab1K0JNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 04:13:48 -0500
X-Sasl-enc: gr7YwL09WARDcH/1CFSdyVRTGxmASuAG3MSyuRTDXsD8 1322385226
Date: Sat, 26 Nov 2011 15:57:27 -0800
From: Greg KH <greg@kroah.com>
To: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: dwmw2@infradead.org, dedekind1@gmail.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 16/16] mtd/docg3: add protection areas sysfs access
Message-ID: <20111126235727.GA12856@kroah.com>
References: <1321714978-24543-1-git-send-email-robert.jarzmik@free.fr>
 <1321714978-24543-17-git-send-email-robert.jarzmik@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321714978-24543-17-git-send-email-robert.jarzmik@free.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 19, 2011 at 04:02:58PM +0100, Robert Jarzmik wrote:
> As each docg3 chip has 2 protection areas (DPS0 and DPS1),
> and because theses areas can prevent user access to the chip
> data, add for each floor the sysfs entries which insert the
> protection key into the right DPS.
> 
> Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>

As you are adding new sysfs files, you also must add Documentation/ABI
entries for them.  Please do so.

thanks,

greg k-h
