Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548Ab2LYDYL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 22:24:11 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:50105 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423Ab2LYDYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 22:24:09 -0500
Message-ID: <50D91A98.5090507@lwfinger.net>
Date: Mon, 24 Dec 2012 21:16:40 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: LKML <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
Subject: Regression in kernel 3.8-rc1 bisected to commit adfa79d: I now get
 many "unable to enumerate USB device" messages
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The problem has been bisected to commit adfa79d entitled "USB: EHCI: make 
ehci-pci a separate driver". The symptom is that my NVIDIA controller again 
reverts to unended logging of messages of the form "hub 2-0:1.0: unable to 
enumerate USB device on port 5".

This behavior was previously fixed with commit c618759.

Thanks,

Larry
