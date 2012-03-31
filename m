Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473Ab2CaC4O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 22:56:14 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47010 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754087Ab2CaC4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 22:56:11 -0400
MIME-Version: 1.0
In-Reply-To: <201203281113.19827.hartleys@visionengravers.com>
References: <201203281113.19827.hartleys@visionengravers.com>
From: Mike Frysinger <vapier@gentoo.org>
Date: Fri, 30 Mar 2012 22:55:47 -0400
X-Google-Sender-Auth: ZYow9D1D5muLKZjfGNx3DgFJNmA
Message-ID: <CAMjpGUfCyXQDeXTS+LKdhbU52YH73-biDHRscsp5Edx4sMTvxA@mail.gmail.com>
Subject: Re: [PATCH 3/5] blackfin: Use the plat_nand default partition parser
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-mtd@lists.infradead.org,
        uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2012 at 14:13, H Hartley Sweeten wrote:
> Use the default partition parser, cmdlinepart, provided by the plat_nand driver.

Acked-by: Mike Frysinger <vapier@gentoo.org>
-mike
