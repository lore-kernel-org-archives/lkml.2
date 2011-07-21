Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751990Ab1GUDmW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 23:42:22 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:61365 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800Ab1GUDmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 23:42:18 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:1aa9:5ff:fe24:37a9]
In-Reply-To: <CAOesGMizAxjcNUBPCeeVgYEbLZB4P+0znua7TjhbqUNn91hgGw@mail.gmail.com>
References: <1311218619-11174-1-git-send-email-achew@nvidia.com>
	<CAOesGMizAxjcNUBPCeeVgYEbLZB4P+0znua7TjhbqUNn91hgGw@mail.gmail.com>
Date: Wed, 20 Jul 2011 20:42:16 -0700
Message-ID: <CAOesGMg5U=vPnE+99TPMGMsdwUBriFtfUwajTvBA5wPZzVpfVw@mail.gmail.com>
Subject: Re: [PATCH 1/3 v3] usb: tegra20-ehci: Add devicetree support.
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

On Wed, Jul 20, 2011 at 8:41 PM, Olof Johansson <olof@lixom.net> wrote:
>> +static struct tegra_utmip_config utmi_default = {
>
> __initdata, no need to keep this around after setup.


Oops, I meant __devinitdata.


-Olof
