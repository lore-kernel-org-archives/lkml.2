Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751345Ab2KOWGp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 17:06:45 -0500
Received: from userp1050.oracle.com ([156.151.31.82]:46905 "EHLO
	userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918Ab2KOWGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 17:06:34 -0500
Date: Thu, 15 Nov 2012 23:43:34 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: YAMANE Toshiaki <yamanetoshi@gmail.com>
Cc: devel@driverdev.osuosl.org, Mauro Carvalho Chehab <mchehab@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 2/4] staging/serqt_usb2: refactor qt_read_bulk_callback()
 in serqt_usb2.c
Message-ID: <20121115204333.GJ11566@mwanda>
References: <1352496782-7246-1-git-send-email-yamanetoshi@gmail.com>
 <1352496836-7280-1-git-send-email-yamanetoshi@gmail.com>
 <20121114124110.GG11515@mwanda>
 <CAOTypNR_dDjg=XA-yP2OhyrLs3LEBPDFSRBORZUPh6Qzo4w8xA@mail.gmail.com>
 <20121115201817.GO11515@mwanda>
 <CAOTypNR3Wa1rpc45kG2W1Yv-6rXD==kxx+m9TC=94m08EefkoQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOTypNR3Wa1rpc45kG2W1Yv-6rXD==kxx+m9TC=94m08EefkoQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: userp1040.oracle.com [156.151.31.81]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Btw:
> +             dev_dbg(&port->dev, "Line status status.\n");
                                     ^^^^^^^^^^^^^^^^^^^
These kind of debug statements which just tell which function is
being called can be deleted.  The function tracer already provides
that information.

> +             fn = ProcessLineStatus;
> +     } else {
> +             dev_dbg(&port->dev, "Modem status status.\n");
> +             fn = ProcessModemStatus;

regards,
dan carpenter

