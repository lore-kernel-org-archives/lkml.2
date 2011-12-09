Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164Ab1LIC0b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 21:26:31 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:37330 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958Ab1LIC0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 21:26:30 -0500
MIME-Version: 1.0
In-Reply-To: <1323333920.10774.1.camel@phoenix>
References: <1323333920.10774.1.camel@phoenix>
Date: Fri, 9 Dec 2011 10:26:29 +0800
Message-ID: <CAN1soZxNWbG3fi9N6VFGiHRcBjcJo2q+W26cwRaXM=c4oTLoog@mail.gmail.com>
Subject: Re: [PATCH] mfd: Avoid writing uninitialized value to device
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Haojian Zhuang <haojian.zhuang@marvell.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 8, 2011 at 4:45 PM, Axel Lin <axel.lin@gmail.com> wrote:
> Avoid writing uninitialized value to device by explicitly initialize
> zero to 0.
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
Acked-by: Haojian Zhuang <haojian.zhuang@gmail.com>
