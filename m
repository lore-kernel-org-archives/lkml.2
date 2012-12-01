Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154Ab2LANmW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 08:42:22 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:52675 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796Ab2LANmV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 08:42:21 -0500
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <50B9EA76.10803@nvidia.com>
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com>
	<1353935954-13763-2-git-send-email-tbergstrom@nvidia.com>
	<20121128212301.GA25531@avionic-0098.adnet.avionic-design.de>
	<50B73710.2040102@nvidia.com>
	<20121129114704.GB6150@avionic-0098.adnet.avionic-design.de>
	<50B874C7.5030208@nvidia.com>
	<20121130103850.GA28367@avionic-0098.adnet.avionic-design.de>
	<50B9EA76.10803@nvidia.com>
Date: Sat, 1 Dec 2012 14:42:18 +0100
X-Google-Sender-Auth: id5hZiaCteKTBB3UZId4fS4ZLV0
Message-ID: <CAKMK7uGnm7M5ad=aeCNiFLYXbJZ9Nx-vsGrstjt5_3BcrqWVqA@mail.gmail.com>
Subject: Re: [RFC v2 1/8] video: tegra: Add nvhost driver
From: Daniel Vetter <daniel@ffwll.ch>
To: =?ISO-8859-1?Q?Terje_Bergstr=F6m?= <tbergstrom@nvidia.com>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 1, 2012 at 12:31 PM, Terje Bergström <tbergstrom@nvidia.com> wrote:
> We must've talked about a bit different things. For pure register defs,
> I can accommodate changing to #defines. We'd lose the code coverage
> analysis, though, but if the parentheses are a make-or-break question to
> upstreaming, I can change.

Out of sheer curiosity: What are you using the coverage data of these
register definitions for? When I looked into coverage analysis the
resulting data seemed rather useless to me, since the important thing
is how well we cover the entire dynamic state space of the hw+sw (e.g.
crap left behind by the bios ...) and coverage seemed to be a poor
proxy for that. Hence why I wonder what you're doing with this data
...
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
