Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932297Ab2F2QGl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 12:06:41 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:40278 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336Ab2F2QGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 12:06:40 -0400
Message-ID: <4FEDD28D.1000303@wwwdotorg.org>
Date: Fri, 29 Jun 2012 10:06:37 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Alexandre Courbot <acourbot@nvidia.com>
CC: Stephen Warren <swarren@nvidia.com>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm: tegra: add Ventana backlight device
References: <1340976299-27601-1-git-send-email-acourbot@nvidia.com>
In-Reply-To: <1340976299-27601-1-git-send-email-acourbot@nvidia.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2012 07:24 AM, Alexandre Courbot wrote:
> Add the backlight device to the Ventana device tree.

As I mentioned downstream, I have a patch to add all the regulators for
Ventana to DT. This patch should be rebased on top of that, since it
adds the backlight regulator node too, but co-locates it with a bunch of
other regulators, so won't merge with this patch.

I hope I'll be able to publish an updated version of the Ventana patch
today.

But aside from that, this patch looks reasonable.
