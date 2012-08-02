Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689Ab2HBNcu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 09:32:50 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:56130 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154Ab2HBNct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 09:32:49 -0400
MIME-Version: 1.0
In-Reply-To: <1343911533-3423-1-git-send-email-shea@shealevy.com>
References: <1343911533-3423-1-git-send-email-shea@shealevy.com>
Date: Thu, 2 Aug 2012 15:32:47 +0200
Message-ID: <CANq1E4Tn6nugb0vmMb1VzTE+-io0bV2y7OLaEXtXbav4W51Kag@mail.gmail.com>
Subject: Re: [PATCH] Bluetooth: Add support for Apple MacBook Pro 9,2
From: David Herrmann <dh.herrmann@googlemail.com>
To: shea@shealevy.com
Cc: Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shea

On Thu, Aug 2, 2012 at 2:45 PM,  <shea@shealevy.com> wrote:
> From: Shea Levy <shea@shealevy.com>
>
>
> Signed-off-by: Shea Levy <shea@shealevy.com>

Why is this patch missing a commit-message? Please add one. And also
include the output of "usb-devices" or the contents of
/sys/kernel/debug/usb/devices in this commit-message.

Regards
David

> ---
>  drivers/bluetooth/btusb.c | 3 +++
>  1 file changed, 3 insertions(+)
