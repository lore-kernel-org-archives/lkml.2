Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757788Ab2CGUvM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 15:51:12 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:53506 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609Ab2CGUvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 15:51:05 -0500
Message-ID: <4F57CA35.50406@wwwdotorg.org>
Date: Wed, 07 Mar 2012 13:51:01 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110921 Thunderbird/3.1.15
MIME-Version: 1.0
To: Simon Glass <sjg@chromium.org>
CC: LKML <linux-kernel@vger.kernel.org>, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Olof Johansson <olof@lixom.net>
Subject: Re: [RESEND PATCH 0/3] arm: tegra: dts: USB Updates for Tegra legacy
 mode / OTG
References: <1331096674-8324-1-git-send-email-sjg@chromium.org>
In-Reply-To: <1331096674-8324-1-git-send-email-sjg@chromium.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2012 10:04 PM, Simon Glass wrote:
> This little series brings in some bindings that seem useful for U-Boot.
> 
> I am working mostly in U-Boot, but since there is no shared .dts repo
> I was asked to commit these changes to the kernel. I do not propose to
> update the Linux USB drivers to match.
> 
> 
> Simon Glass (3):
>   arm: tegra: dts: Support host/device selection and legacy mode
>   arm: tegra: dts: Add legacy mode support to Tegra2x USB1 port
>   arm: tegra: dts: Mark USB1 as an OTG port on Seaboard

I ack'd this before, but just in case it got lost: The series,

Acked-by: Stephen Warren <swarren@wwwdotorg.org>
