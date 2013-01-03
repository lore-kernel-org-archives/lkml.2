Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902Ab3ACU3i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 15:29:38 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:48630 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497Ab3ACU3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 15:29:35 -0500
Message-ID: <50E5EA2C.609@wwwdotorg.org>
Date: Thu, 03 Jan 2013 13:29:32 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: gregkh@linuxfoundation.org
CC: Venu Byravarasu <vbyravarasu@nvidia.com>, stern@rowland.harvard.edu,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 2/2] usb: host: tegra: Resetting PORT0 based on
 information received via DT.
References: <1357198179-10031-1-git-send-email-vbyravarasu@nvidia.com> <1357198179-10031-3-git-send-email-vbyravarasu@nvidia.com>
In-Reply-To: <1357198179-10031-3-git-send-email-vbyravarasu@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03/2013 12:29 AM, Venu Byravarasu wrote:
> Tegra USB host driver is using port instance number,
> to handle some of the hardware issues on SOC e.g. reset PORT0
> twice etc. As instance number based handling looks ugly,
> making use of information passed through DT for achieving this.
> 
> Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
> Acked-by: Alan Stern <stern@rowland.harvard.edu>

Greg, recall that I'm hoping to take this series through the Tegra tree
in order to manage EHCI/PHY/clock dependencies. I'm hoping to get your
ack if required, or is Alan's sufficient for this? Thanks.
