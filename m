Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932663Ab1ALCTH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 21:19:07 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47344 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756389Ab1ALCTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 21:19:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=lk9OgGSbfrdHaTao1PD7GsIG2dn05a6sWd/VMjHO7ajD0Hf4JBQq2puvqvjHymTx9/
         fOpVRnRjgFpSoIy3wy5Hh6FFkdPtx5yEV7f7VudGiDXOvxO4NWqQw+8MIkToGhxq4BQQ
         XKITEkOdRXKRQJ5GL217jgdsdYJ+JoNqpOxEE=
MIME-Version: 1.0
In-Reply-To: <1294797775.20409.4.camel@mola>
References: <1294797775.20409.4.camel@mola>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 11 Jan 2011 21:18:44 -0500
Message-ID: <AANLkTinGU1KT+8y7B9WGph42MRwQdNQZ=gujWmNF8RWr@mail.gmail.com>
Subject: Re: [PATCH] ASoC: Fix parameter for soc_unregister_ac97_dai_link
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>, stable@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 11, 2011 at 21:02, Axel Lin wrote:
> soc_unregister_ac97_dai_link takes a pointer to a codec.

thanks ... seems to work for me
Acked-by: Mike Frysinger <vapier@gentoo.org>
-mike
