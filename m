Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020Ab2DCOMe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 10:12:34 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:39230 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754847Ab2DCOLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 10:11:54 -0400
Date: Tue, 3 Apr 2012 10:11:52 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Nicolas Ferre <nicolas.ferre@atmel.com>
cc: linux-arm-kernel@lists.infradead.org, <linux-usb@vger.kernel.org>,
        <plagnioj@jcrosoft.com>, <ludovic.desroches@atmel.com>,
        <linux-kernel@vger.kernel.org>, <arnd@arndb.de>, <olof@lixom.net>
Subject: Re: [PATCH v2 06/13] USB: ohci-at91: change maximum number of ports
In-Reply-To: <80824c8cde04604acd313b93205260b2ad082a4b.1333437885.git.nicolas.ferre@atmel.com>
Message-ID: <Pine.LNX.4.44L0.1204030954590.1537-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Apr 2012, Nicolas Ferre wrote:

> Change number of ports to 3 for newer SoCs. Modify pdata structure
> and ohci-at91 code that was dealing with ports information and check
> of port indexes.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

Did you run this patch through scripts/checkpatch.pl?  I have the 
feeling that it might complain about some of the changes.

Alan Stern

