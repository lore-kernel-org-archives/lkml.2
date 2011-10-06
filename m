Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040Ab1JFEKd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 00:10:33 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:37771 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829Ab1JFEKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 00:10:32 -0400
Date: Thu, 6 Oct 2011 09:40:11 +0530
From: Himanshu Chauhan <hschauhan@nulltrace.org>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, kernelnewbies@kernelnewbies.org,
        lm-sensors@lm-sensors.org
Subject: Re: [PATCH] hwmon class driver registration with a device number
Message-ID: <20111006041011.GB2125@ubuntu.ubuntu-domain>
References: <1317834791-2803-1-git-send-email-hschauhan@nulltrace.org>
 <20111005193359.GB26664@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111005193359.GB26664@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

> 
> How do you later remove a device created with this new interface?  As it
> is, I think the existing calls will fail, right?
> 
If I have not missed out anything from hwmon_device_unregister(), it shouldn't
fail. Why did you point that out?

-Himanshu
