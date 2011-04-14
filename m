Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758774Ab1DNLDj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 07:03:39 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39774 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758728Ab1DNLDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 07:03:37 -0400
Message-ID: <4DA6D429.3000801@ru.mvista.com>
Date: Thu, 14 Apr 2011 15:02:01 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Juergen Kilb <J.Kilb@phytec.de>
CC: linux-arm-kernel@lists.infradead.org, dbrownell@users.sourceforge.net,
        balbi@ti.com, gregkh@suse.de, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com
Subject: Re: [PATCH] Fixed gpio polarity of gpio USB-phy reset.
References: <1302766303-1157-1-git-send-email-J.Kilb@phytec.de>
In-Reply-To: <1302766303-1157-1-git-send-email-J.Kilb@phytec.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 14-04-2011 11:31, Juergen Kilb wrote:

> With commit 19403165 a main part of ehci-omap.c moved to
> drivers/mfd/omap-usb-host.c created by commit 17cdd29d.

    Pelase also specify the summaries of those commits -- for the human readers.

> Due to this reorganisation the polarity used to reset the
> external USB phy changed and USB host doesn't recognize
> any devices.

> Signed-off-by: Juergen Kilb <J.Kilb@phytec.de>

WBR, Sergei
