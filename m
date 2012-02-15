Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760251Ab2BOOkF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 09:40:05 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:60551 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758396Ab2BOOkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 09:40:01 -0500
MIME-Version: 1.0
In-Reply-To: <201202150953.20341.oneukum@suse.de>
References: <1329230375-25508-1-git-send-email-toby.gray@realvnc.com>
	<20120214.144622.678577766818888054.davem@davemloft.net>
	<CAL_Kpj0VSu-ByUEwTeVG5-5psab3h38bTL=ot7vYD8A+Oeb_Ug@mail.gmail.com>
	<201202150953.20341.oneukum@suse.de>
Date: Wed, 15 Feb 2012 15:40:00 +0100
Message-ID: <CAL_Kpj0oN883qGhAD2pO4zOHvYt1=VmQHOJx970UF0TcqG06OA@mail.gmail.com>
Subject: Re: [PATCH 1/1] usb: cdc-ncm: Increase maximum allowed datagram size
From: Alexey Orishko <alexey.orishko@gmail.com>
To: Oliver Neukum <oneukum@suse.de>
Cc: David Miller <davem@davemloft.net>, toby.gray@realvnc.com,
        oliver@neukum.name, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 15, 2012 at 9:53 AM, Oliver Neukum <oneukum@suse.de> wrote:
> Have you tried that under severe memory presssure?

Well, it is a simplistic view upon host configuration.
Developing of NCM spec was done with mind set, that host must be more
capable than device.

However, proposal above doesn't solve problem completely due to usbnet.
Currently I'm testing some improvements/fixes related to data handling
and driver latency with the plan to post it in the near future.

Regards,
Alexey
