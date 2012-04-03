Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921Ab2DCPZ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 11:25:56 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:39320 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751652Ab2DCPZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 11:25:55 -0400
Date: Tue, 3 Apr 2012 11:25:53 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Nicolas Ferre <nicolas.ferre@atmel.com>
cc: plagnioj@jcrosoft.com, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>, <ludovic.desroches@atmel.com>,
        <linux-kernel@vger.kernel.org>, <arnd@arndb.de>, <olof@lixom.net>
Subject: Re: [PATCH v2 06/13] USB: ohci-at91: change maximum number of ports
In-Reply-To: <4F7B1174.5070300@atmel.com>
Message-ID: <Pine.LNX.4.44L0.1204031125060.1537-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Apr 2012, Nicolas Ferre wrote:

> > Did you run this patch through scripts/checkpatch.pl?  I have the 
> > feeling that it might complain about some of the changes.
> 
> Yes, definitively.
> 
> I can modify the patch to comply with error issued by checkpatch.pl: several are
> due to a bad replacement of previous code with my regular expression but others
> where existing before my modifications.
> So what do you think about:
>  - addressing all style errors in this patch (to prevent carrying them)
>  - merging this one and the following patch:
>    "[PATCH v2 07/13] USB: ohci-at91: coding style modifications with one-line ifs
>  - posting a v3 of this patch only if you agree on this...

Sure, go ahead.  Aside from this minor issue I didn't notice anything 
objectionable in the patch series.

Alan Stern

