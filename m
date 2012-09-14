Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009Ab2INGxD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 02:53:03 -0400
Received: from shmail0.sohard.de ([212.114.139.117]:52958 "EHLO
	shmail0.sohard.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298Ab2INGxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 02:53:00 -0400
Date: Fri, 14 Sep 2012 08:52:58 +0200 (CEST)
From: Rene Buergel <rene.buergel@sohard.de>
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/4]: ezusb: move ezusb.c from drivers/usb/serial to drivers/usb/misc
Message-ID: <6bca77b6-f91c-4ec2-acb2-91b892303502@shmail0>
In-Reply-To: <20120914050328.GB21944@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [77.190.66.255]
X-Mailer: Zimbra 7.1.3_GA_3374 (ZimbraWebClient - FF3.0 (Win)/7.1.3_GA_3346)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Git should show this as a move, not as a "add a file and remove a
> file"
> type patch.  Are you generating it properly?

Whats the proper way to do this? I did a git mv, git commit and than git diff on that commit hash.


> Also, why move it?  Are there other modules that need to use it?
> 
> thanks,
> 
> greg k-h
> 

we discussed this a while ago, i had some trouble getting the patches due to changing my workplace.
