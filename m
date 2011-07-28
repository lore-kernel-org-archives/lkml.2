Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454Ab1G1K6z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 06:58:55 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64509 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754481Ab1G1K6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 06:58:54 -0400
Message-ID: <4E3140D2.90608@ru.mvista.com>
Date: Thu, 28 Jul 2011 14:58:26 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: Andrew Bird <ajb@spheresystems.co.uk>
CC: gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] USB: option driver: add PID for Vodafone-Huawei K3770
References: <1311782600-13353-1-git-send-email-ajb@spheresystems.co.uk>
In-Reply-To: <1311782600-13353-1-git-send-email-ajb@spheresystems.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 27-07-2011 20:03, Andrew Bird wrote:

> This patch adds the product ID of Huawei's Vodafone K3770 mobile broadband
> modem to option.c. This is necessary so that the driver gets loaded on demand
> without the intervention of usb_modeswitch. This has the benefit of it becoming
> available faster and also ensures that the option driver is not bound to a
> network interface that should be claimed by cdc_ether.

    You seem to be adding 4 product IDs with the identical patch descriptions. 
Why not do it in a single patch?

> Signed-off-by: Andrew Bird <ajb@spheresystems.co.uk>

WBR, Sergei
