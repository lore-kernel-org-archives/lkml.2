Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807Ab3AJQQz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 11:16:55 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:40508 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613Ab3AJQQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 11:16:53 -0500
Message-ID: <50EEF713.1080705@mvista.com>
Date: Thu, 10 Jan 2013 20:14:59 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: select USB_ARCH_HAS_EHCI for MXS
References: <1357832136-16043-1-git-send-email-maxime.ripard@free-electrons.com>
In-Reply-To: <1357832136-16043-1-git-send-email-maxime.ripard@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 01/10/2013 06:35 PM, Maxime Ripard wrote:

> Commit 09f6ffde introduced a dependency on USB_EHCI_HCD for the chipidea

   Please also specify the summary of that commit in parens (or however you like).

> USB host driver, that in turns depends on USB_ARCH_HAS_EHCI.

> If this symbol is not set for MXS, the MXS boards are not able to use the
> chipidea driver anymore.

> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>

WBR, Sergei

