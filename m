Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193Ab2EBNlj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 09:41:39 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:61451 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013Ab2EBNlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 09:41:37 -0400
MIME-Version: 1.0
In-Reply-To: <1333956052-25319-2-git-send-email-tinamdar@apm.com>
References: <1333956052-25319-1-git-send-email-tinamdar@apm.com>
	<1333956052-25319-2-git-send-email-tinamdar@apm.com>
Date: Wed, 2 May 2012 09:41:37 -0400
Message-ID: <CA+5PVA4HGVGRbnLCMOAbO1mYnFCgHhh1_ErLdKq5YhMdV0VhQw@mail.gmail.com>
Subject: Re: [V2 2/5] powerpc: 40x: Add AHB, APB of_device_ids
From: Josh Boyer <jwboyer@gmail.com>
To: Tanmay Inamdar <tinamdar@apm.com>
Cc: benh@kernel.crashing.org, grant.likely@secretlab.ca,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 9, 2012 at 3:20 AM, Tanmay Inamdar <tinamdar@apm.com> wrote:
> Adding of_device_id's for AHB and APB buses used in klondike (APM8018X) in
> platforms/40x/ppc40x_simple.c file
>
> Signed-off-by: Tanmay Inamdar <tinamdar@apm.com>

You should probably combine the first 3 patches in this series into one
patch.  Otherwise you run the risk of changing the DTS to something the
kernel can't support.  At the least, this change should be patch 1 in
the series, and you can probably combine the two DTS changes.

josh
