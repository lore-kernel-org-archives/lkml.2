Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932766Ab1JZLSw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 07:18:52 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38739 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932673Ab1JZLSu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 07:18:50 -0400
MIME-Version: 1.0
In-Reply-To: <CAM8FrKKPjvmtqo2v_xjQBw+xBoBypynp_YdwkXThm=EVyU2y9Q@mail.gmail.com>
References: <CAM8FrKKPjvmtqo2v_xjQBw+xBoBypynp_YdwkXThm=EVyU2y9Q@mail.gmail.com>
Date: Wed, 26 Oct 2011 13:18:49 +0200
Message-ID: <CAM8FrK+mh3AWiS+9=VWwziFox7reeA-sZQthnBzCfRXS+gQS1Q@mail.gmail.com>
Subject: Re: [PATCH] regulator: Use regmap_read/write(), regmap_update_bits
 functions directly
From: Marcus Folkesson <marcus.folkesson@gmail.com>
To: jhbird.choi@samsung.com
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, I was wrong.

2011/10/26 Marcus Folkesson <marcus.folkesson@gmail.com>:
> Is'nt this change already made in commit
> 90923351d480fffd0d24646db83f6f8315eed0d9 ?
>
> Are you using an old kernel version?
>
> Copy from the git log:
>
> commit 90923351d480fffd0d24646db83f6f8315eed0d9
> Author: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Date:   Sat Jun 18 01:18:51 2011 +0100
>
>    regulator: Convert tps65023 to use regmap API
>
>    Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
>    Acked-by: Liam Girdwood <lrg@ti.com>
>    Acked-by: Grant Likely <grant.likely@secretlab.ca>
>
>
> Med vänliga hälsningar / Best regards
> Marcus Folkesson
>
