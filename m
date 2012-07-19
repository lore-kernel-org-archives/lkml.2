Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751144Ab2GSEEi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 00:04:38 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56907 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667Ab2GSEEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 00:04:36 -0400
Message-ID: <5007874F.6090707@pobox.com>
Date: Thu, 19 Jul 2012 00:04:31 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: "K. Y. Srinivasan" <kys@microsoft.com>, gregkh@linuxfoundation.org
CC: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, olaf@aepfle.de, apw@canonical.com
Subject: Re: [PATCH 1/1] Drivers: hv: Change the hex constant to a decimal
 constant
References: <1342652245-931-1-git-send-email-kys@microsoft.com>
In-Reply-To: <1342652245-931-1-git-send-email-kys@microsoft.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2012 06:57 PM, K. Y. Srinivasan wrote:
> The hex constant chosen for HV_LINUX_GUEST_ID_HI was offensive, update 
> to use
> the decimal equivalent instead.
>
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>

Acked-by: Jeff Garzik <jgarzik@redhat.com>


