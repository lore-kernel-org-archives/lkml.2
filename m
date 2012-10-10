Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757256Ab2JJU24 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 16:28:56 -0400
Received: from smtprelay-b12.telenor.se ([62.127.194.21]:40056 "EHLO
	smtprelay-b12.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757180Ab2JJU2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 16:28:51 -0400
X-SENDER-IP: [85.230.29.114]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnCbAJbZdVBV5h1yPGdsb2JhbABEhSkiAYUAs2YEexkBAQEBHxkNJ4JhHCMYF0YlChoKCYgIt3QUizMvA4UOYAOVa4VyjS4
X-IronPort-AV: E=Sophos;i="4.80,566,1344204000"; 
   d="scan'208";a="424221025"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Wed, 10 Oct 2012 22:31:18 +0200
To: Hans de Goede <hdegoede@redhat.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: REGRESSION: usbdevfs:
 Use-scatter-gather-lists-for-large-bulk-transfers
Message-ID: <20121010203118.GA792@polaris.bitmath.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hans, Alan, Greg,

commit 3d97ff63f8997761f12c8fbe8082996c6eeaba1a
Author: Hans de Goede <hdegoede@redhat.com>
Date:   Wed Jul 4 09:18:03 2012 +0200

    usbdevfs: Use scatter-gather lists for large bulk transfers
    
breaks an usb programming cable over here. The problem is reported as
"bulk tranfer failed" [sic] by the tool, and bisection leads to this
commit. Reverting on top of 3.6 solves it for me.

I am happy to test alternatives.

Thanks,
Henrik
