Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753791Ab1GUVhE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 17:37:04 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:47742 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549Ab1GUVg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 17:36:59 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:1aa9:5ff:fe24:37a9]
In-Reply-To: <1311283067-18952-1-git-send-email-achew@nvidia.com>
References: <1311283067-18952-1-git-send-email-achew@nvidia.com>
Date: Thu, 21 Jul 2011 14:36:57 -0700
Message-ID: <CAOesGMhGXxvoxJ590d29vXbbn4EREWRkR8Q3oS4Sp1WhgYiMcg@mail.gmail.com>
Subject: Re: [PATCH 1/3 v4] usb: tegra20-ehci: Add devicetree support.
From: Olof Johansson <olof@lixom.net>
To: achew@nvidia.com
Cc: grant.likely@secretlab.ca, swarren@nvidia.com, dwillemsen@nvidia.com,
        rklein@nvidia.com, mogantyv@nvidia.com,
        devicetree-discuss@lists.ozlabs.org, linux-tegra@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 21, 2011 at 2:17 PM,  <achew@nvidia.com> wrote:
> From: Andrew Chew <achew@nvidia.com>
>
> Add code to try to get platform data information (register base, irq,
> modes, various tuning parameters) from device tree, if not present in board
> files.
>
> Signed-off-by: Andrew Chew <achew@nvidia.com>
> Acked-by: Stephen Warren <swarren@nvidia.com>

Acked-by: Olof Johansson <olof@lixom.net>


-Olof
