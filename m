Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756434Ab2KIV4f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 16:56:35 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:54429 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755881Ab2KIV4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 16:56:32 -0500
Message-ID: <509D7C0D.6010704@wwwdotorg.org>
Date: Fri, 09 Nov 2012 14:56:29 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ARM: tegra: tamonten: Add DDC/PTA pinmux
References: <1352466291-27333-1-git-send-email-thierry.reding@avionic-design.de>
In-Reply-To: <1352466291-27333-1-git-send-email-thierry.reding@avionic-design.de>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2012 06:04 AM, Thierry Reding wrote:
> This commit allows the I2C2 controller on Tegra20 to be routed either to
> the DDC or the PTA pin group at runtime. On Tamonten this allows the I2C
> bus to be used for the DDC of the HDMI connector or to access I2C chips
> on the carrier board.

Both patches applied to Tegra's for-3.8/dt branch. Thanks.
