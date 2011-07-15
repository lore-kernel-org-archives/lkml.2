Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932668Ab1GOCtJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 22:49:09 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:36592 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932472Ab1GOCtH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 22:49:07 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <20110715024330.GG32716@opensource.wolfsonmicro.com>
References: <1310650159.6854.1.camel@phoenix> <20110714234805.GA32716@opensource.wolfsonmicro.com>
 <CAF+7xWnOZkOpMSiOBJKA2HMpstzqUt1GT3Gr+g783trYH+kj3A@mail.gmail.com> <20110715024330.GG32716@opensource.wolfsonmicro.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Fri, 15 Jul 2011 10:48:46 +0800
Message-ID: <CAF+7xWk4sPUfPaK7uys9rpzuEzH3bj3SeYJptteDnP=hfKUoFQ@mail.gmail.com>
Subject: Re: [PATCH] regulator: Fix memory leak in set_machine_constraints()
 error paths
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So, then does this perhaps open paths where ret might be used
> uninitialized?  In general this seems like an unrelated stylistic change
> which is unfortunately hard to review from a context diff alone.
>
I got your point. will send a new version of the patch.

Thanks,
Axel
