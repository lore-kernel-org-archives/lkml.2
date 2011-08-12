Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750852Ab1HLEDg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 00:03:36 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:49102 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760Ab1HLEDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 00:03:35 -0400
MIME-Version: 1.0
In-Reply-To: <20110811232735.u5qoybpr4gg8kckw@webmail.mit.edu>
References: <1312817901-5313-1-git-send-email-wangshaoyan.pt@taobao.com>
	<CAErSpo6Fh+zTMiSG+mjkNuA03cCEK7bej9y2oX+HfsScSYGFsw@mail.gmail.com>
	<CANxBZFrzmTDaUrmkGhKAVsZpXScEDxdJeBzcMbBjEW=6ozppGw@mail.gmail.com>
	<20110811232735.u5qoybpr4gg8kckw@webmail.mit.edu>
Date: Fri, 12 Aug 2011 12:03:34 +0800
Message-ID: <CANxBZFpjtGyk3CO0ViFJF8em_hBFLq7tErjMJrcq5vC7n9cy4g@mail.gmail.com>
Subject: Re: [PATCH] pnp: replace deprecated __check_region to request_region
From: Wang Shaoyan <stufever@gmail.com>
To: Adam M Belay <abelay@mit.edu>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        Wang Shaoyan <wangshaoyan.pt@taobao.com>, linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Adam,

I can understand your worry, but back to beginning, just as the
subject of the patch: "replace deprecated __check_region to
request_region", I think this patch is still need, although it can't
solve the problems both you guys mentioned. Do you agree it?

2011/8/12 Adam M Belay <abelay@mit.edu>:
> Hi Wang,
>
> Yes, I think your description of the race condition is right. However, as
> Bjorn
> mentioned, there are many x86 init paths that will try to reserve the same
> resources as those reported by pnp/acpi. There needs to be a better way to
> coordinate legacy device enumeration. Otherwise, the request_region() calls
> could fail when there isn't an actual resource conflict.
>
> IF we could find a good way to clean up the legacy users of request_region()
> then we could probably make pnp behave more like pci with regard to resource
> reservations.
>
> Cheers,
> Adam


-- 
Wang Shaoyan
