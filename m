Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490Ab2KOU7d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 15:59:33 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:58202 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358Ab2KOU7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 15:59:32 -0500
MIME-Version: 1.0
In-Reply-To: <20121115204333.GJ11566@mwanda>
References: <1352496782-7246-1-git-send-email-yamanetoshi@gmail.com>
	<1352496836-7280-1-git-send-email-yamanetoshi@gmail.com>
	<20121114124110.GG11515@mwanda>
	<CAOTypNR_dDjg=XA-yP2OhyrLs3LEBPDFSRBORZUPh6Qzo4w8xA@mail.gmail.com>
	<20121115201817.GO11515@mwanda>
	<CAOTypNR3Wa1rpc45kG2W1Yv-6rXD==kxx+m9TC=94m08EefkoQ@mail.gmail.com>
	<20121115204333.GJ11566@mwanda>
Date: Fri, 16 Nov 2012 05:53:11 +0900
Message-ID: <CAOTypNTkeU03_gbA8CHAGR8QiF2JPgd=z4YMtd85_v+Zn4frQg@mail.gmail.com>
Subject: Re: [PATCH 2/4] staging/serqt_usb2: refactor qt_read_bulk_callback()
 in serqt_usb2.c
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: devel@driverdev.osuosl.org, Mauro Carvalho Chehab <mchehab@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 5:43 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
>
> Btw:
>> +             dev_dbg(&port->dev, "Line status status.\n");
>                                      ^^^^^^^^^^^^^^^^^^^
> These kind of debug statements which just tell which function is
> being called can be deleted.  The function tracer already provides
> that information.

I did not know that. Thanks!

>> +             fn = ProcessLineStatus;
>> +     } else {
>> +             dev_dbg(&port->dev, "Modem status status.\n");
>> +             fn = ProcessModemStatus;
>
> regards,
> dan carpenter
>



-- 

Regards,

YAMANE Toshiaki
