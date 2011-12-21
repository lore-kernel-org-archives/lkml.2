Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830Ab1LUL3x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 06:29:53 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:63197 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390Ab1LUL3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 06:29:51 -0500
MIME-Version: 1.0
X-Originating-IP: [93.172.169.13]
In-Reply-To: <1323863315-8159-1-git-send-email-ohad@wizery.com>
References: <1323863315-8159-1-git-send-email-ohad@wizery.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Wed, 21 Dec 2011 13:29:30 +0200
Message-ID: <CAK=WgbYGFyyB2o0Ppx9GcMbg+nAMxybat3SpBHBMAntzEkygcg@mail.gmail.com>
Subject: Re: [PATCH 0/7] remoteproc/rpmsg: a few trivial fixes
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Mark Grosen <mgrosen@ti.com>, Stephen Boyd <sboyd@codeaurora.org>,
        Ohad Ben-Cohen <ohad@wizery.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 1:48 PM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
> Two fixes from Mark (required for controlling non-IOMMU and non-Virtio
> remote processors via remoteproc), two fixes which were reported by
> Stephen Boyd, and three other trivial cleanups.

Applied and pushed to 'for-next'.
