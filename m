Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933037Ab2GEN03 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 09:26:29 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:34249 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932483Ab2GEN02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 09:26:28 -0400
MIME-Version: 1.0
In-Reply-To: <1340945879-11712-2-git-send-email-acourbot@nvidia.com>
References: <1340945879-11712-1-git-send-email-acourbot@nvidia.com>
	<1340945879-11712-2-git-send-email-acourbot@nvidia.com>
Date: Thu, 5 Jul 2012 15:26:27 +0200
Message-ID: <CACRpkdbjHCc0pud8hnjJi1AMM5XQUmS=duhSnzXO+QO29YLk0A@mail.gmail.com>
Subject: Re: [PATCH 1/2] of: return -ENOENT when no property
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexandre Courbot <acourbot@nvidia.com>,
        Rob Herring <rob.herring@calxeda.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 29, 2012 at 6:57 AM, Alexandre Courbot <acourbot@nvidia.com> wrote:

> Make of_parse_phandle_with_args return -ENOENT instead of -EINVAL when
> no matching property is found, which allows to discriminate between
> absence of property and parsing error.
>
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>

Rob can you take this into the DT git?

Yours,
Linus Walleij
