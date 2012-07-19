Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609Ab2GSDHn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 23:07:43 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:62739 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583Ab2GSDHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 23:07:42 -0400
MIME-Version: 1.0
In-Reply-To: <1342560756-18737-12-git-send-email-tytso@mit.edu>
References: <1342560756-18737-1-git-send-email-tytso@mit.edu>
	<1342560756-18737-12-git-send-email-tytso@mit.edu>
Date: Thu, 19 Jul 2012 11:07:40 +0800
Message-ID: <CAN1soZweV6MPKH39h7VA4TDeSxsFq=zwN-FARN8K_iO0Yq1jbQ@mail.gmail.com>
Subject: Re: [PATCH 11/17] pxa25x_udc: remove IRQF_SAMPLE_RANDOM which is now
 a no-op
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2012 at 5:32 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> With the changes in the random tree, IRQF_SAMPLE_RANDOM is now a
> no-op; interrupt randomness is now collected unconditionally in a very
> low-overhead fashion; see commit 775f4b297b.  The IRQF_SAMPLE_RANDOM
> flag was scheduled to be removed in 2009 on the
> feature-removal-schedule, so this patch is preparation for the final
> removal of this flag.
>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> Cc: Eric Miao <eric.y.miao@gmail.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
> ---
>  drivers/usb/gadget/pxa25x_udc.c | 12 ++++--------
>  1 file changed, 4 insertions(+), 8 deletions(-)
>
Acked-by: Haojian Zhuang <haojian.zhuang@gmail.com>
