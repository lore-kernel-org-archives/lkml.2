Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751450Ab1KWFC6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 00:02:58 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:49579 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777Ab1KWFC4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 00:02:56 -0500
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1111221125040.2466-100000@iolanthe.rowland.org>
References: <1321970616-1298-1-git-send-email-amandeep3986@gmail.com>
	<Pine.LNX.4.44L0.1111221125040.2466-100000@iolanthe.rowland.org>
Date: Wed, 23 Nov 2011 10:32:55 +0530
Message-ID: <CAJ54Ua5=z=yh6HOfkLiXu75hHjqcSzj=5z5rUxmRr2DZ=J6_UQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] xHCI: Adding #define values used for hub descriptor
From: Aman Deep <amandeep3986@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

>
> This is good.  Can you also add similar changes to hub_configure() in
> drivers/usb/core/hub.c?
>

Thanks, Alan. I will try to make similar changes into hub_configure()
and other host
controller drivers also.

- Aman
