Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932092Ab1KVVno (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 16:43:44 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:47545 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874Ab1KVVnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 16:43:43 -0500
Subject: Re: [PATCH 1/2] MTD: NAND: ndfc: fix compilation error
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Tanmay Inamdar <tinamdar@apm.com>
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Tue, 22 Nov 2011 23:43:38 +0200
In-Reply-To: <1321942850-20012-1-git-send-email-tinamdar@apm.com>
References: <1321942850-20012-1-git-send-email-tinamdar@apm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1321998220.2222.22.camel@koala>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-22 at 11:50 +0530, Tanmay Inamdar wrote:
> This patch fixes compilation error in ndfc flash driver
> ---
>  drivers/mtd/nand/ndfc.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Tony Breeds <tony@bakeyournoodle.com> sent a fix for this a bit earlier.

Artem.

