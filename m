Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833Ab2A2V2G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 16:28:06 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57138 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752255Ab2A2V2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 16:28:05 -0500
Date: Sun, 29 Jan 2012 21:28:00 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: Add empty devm_regulator_free for
 !CONFIG_REGULATOR
Message-ID: <20120129212759.GA2994@opensource.wolfsonmicro.com>
References: <1327804218.16295.1.camel@phoenix>
 <CAF+7xWn2AkcEyOb5FmXNbGA7U2=n83kvAz+=GGLMh+8yNm8UKw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF+7xWn2AkcEyOb5FmXNbGA7U2=n83kvAz+=GGLMh+8yNm8UKw@mail.gmail.com>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 29, 2012 at 05:42:51PM +0800, Axel Lin wrote:

> Mark, I guess what you want is to declare devm_regulator_put instead
> of devm_regulator_free
> in consumer.h.

Yes, indeed - put to match the get.
