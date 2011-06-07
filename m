Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932434Ab1FGVfL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 17:35:11 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:45144 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932384Ab1FGVfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 17:35:09 -0400
X-Sasl-enc: HPnlx4PDVX4McGW2V/HZqnFs5fCOTfxwOLprxv88l/cL 1307482507
Date: Tue, 7 Jun 2011 14:31:59 -0700
From: Greg KH <greg@kroah.com>
To: =?iso-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Matt Mooney <mfm@muteddisk.com>,
        Kulikov Vasiliy <segooon@gmail.com>, Endre Kollar <taxy443@gmail.com>,
        Arjan Mels <arjan.mels@gmx.net>, Ilia Mirkin <imirkin@alum.mit.edu>,
        David Chang <dchang@novell.com>,
        Himanshu Chauhan <hschauhan@nulltrace.org>,
        Max Vozeler <max@vozeler.com>, Arnd Bergmann <arnd@arndb.de>,
        usbip-devel@lists.sourceforge.net, devel@driverdev.osuosl.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usbip: handle length at sysfs show() functions
Message-ID: <20110607213158.GA11102@kroah.com>
References: <4DE5CA9F.6010303@freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4DE5CA9F.6010303@freemail.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 01, 2011 at 07:14:07AM +0200, Németh Márton wrote:
> From: Márton Németh <nm127@freemail.hu>
> 
> The sysfs show() functions shall return the actual content length of
> the result buffer. According to Documentation/filesystems/sysfs.txt:215
> the scnprintf() function is preferred.
> 
> See also the article titled "snprintf() confusion" at
> http://lwn.net/Articles/69419/ .
> 
> Signed-off-by: Márton Németh <nm127@freemail.hu>

This does not apply anymore, care to redo it?

thanks,

greg k-h
