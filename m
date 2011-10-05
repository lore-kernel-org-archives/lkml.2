Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934963Ab1JETfU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 15:35:20 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:54666 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933233Ab1JETfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 15:35:17 -0400
X-Sasl-enc: OzDelqnUrlcl1PJPdrdNEN6LVBnMFBNZNXj2+Sgg6suv 1317843316
Date: Wed, 5 Oct 2011 12:33:59 -0700
From: Greg KH <greg@kroah.com>
To: Himanshu Chauhan <hschauhan@nulltrace.org>
Cc: linux-kernel@vger.kernel.org, kernelnewbies@kernelnewbies.org
Subject: Re: [PATCH] hwmon class driver registration with a device number
Message-ID: <20111005193359.GB26664@kroah.com>
References: <1317834791-2803-1-git-send-email-hschauhan@nulltrace.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317834791-2803-1-git-send-email-hschauhan@nulltrace.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 05, 2011 at 10:43:11PM +0530, Himanshu Chauhan wrote:
> This patch adds a way to register a hwmon class driver
> with a device number rather than the default MK_DEV(0,0).
> This would help in creating required "dev" file under
> sysfs which in turn can be used in populating /dev tree
> during bootup (helpful to driver which want to show up
> a char interface along with sysfs).

How do you later remove a device created with this new interface?  As it
is, I think the existing calls will fail, right?

greg k-h
