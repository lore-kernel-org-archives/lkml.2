Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752444Ab2LTMty (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 07:49:54 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:46330 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592Ab2LTMts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 07:49:48 -0500
X-Greylist: delayed 321 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Dec 2012 07:49:47 EST
Message-ID: <50D3082C.7070008@mvista.com>
Date: Thu, 20 Dec 2012 16:44:28 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Venu Byravarasu <vbyravarasu@nvidia.com>
CC: swarren@wwwdotorg.org, balbi@ti.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH v2] usb: phy: using kzalloc instead of kmalloc
References: <1355991951-3503-1-git-send-email-vbyravarasu@nvidia.com>
In-Reply-To: <1355991951-3503-1-git-send-email-vbyravarasu@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 20-12-2012 12:25, Venu Byravarasu wrote:

> As Tegra PHY driver open is using kmalloc,
> changing it to kzalloc.

    This description doesn't make sense.

> Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>

WBR, Sergei

