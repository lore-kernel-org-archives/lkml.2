Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932435Ab1FAUT2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 16:19:28 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:61316 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758845Ab1FAUT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 16:19:27 -0400
MIME-Version: 1.0
In-Reply-To: <1306921767-31115-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1306921767-31115-1-git-send-email-broonie@opensource.wolfsonmicro.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 1 Jun 2011 14:19:07 -0600
X-Google-Sender-Auth: TOr-QMk2sLlCbNFUz5i6WgVFfKc
Message-ID: <BANLkTi=KEFG1LHdX2Cn6_CoL+i0cK8EPyA@mail.gmail.com>
Subject: Re: [PATCH] FRV: Hook up gpiolib support
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
        grant@secretlab.ca
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 1, 2011 at 3:49 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> Allow people to use gpiolib on FRV, mostly for build coverage as it
> seems more useful to standardise the API than handle making it optional.
>
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Acked-by: Grant Likely <grant.likely@secretlab.ca>

g.
