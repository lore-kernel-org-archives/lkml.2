Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759448Ab0LNP5B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 10:57:01 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37723 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758337Ab0LNP5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 10:57:00 -0500
Subject: Re: linux-next: build failure after merge of the voltage tree
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Yong Shen <yong.shen@linaro.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTimxnunX6rmV8vCTCmwMuDoD3HTppHjkHGxg4ZKJ@mail.gmail.com>
References: <20101214154933.a4b36f69.sfr@canb.auug.org.au>
	 <AANLkTimxnunX6rmV8vCTCmwMuDoD3HTppHjkHGxg4ZKJ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 14 Dec 2010 15:56:55 +0000
Message-ID: <1292342215.3316.17.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-12-14 at 13:10 +0800, Yong Shen wrote:
> Hi Stephen,
> 
> I had already noticed Liam. Mc13892's patch depends on other two
> patches which are not applied yet.
> 

All applied now. 

Yong, in the future please wait until patches are applied before sending
new dependent patches. This series and the last were quite confusing to
deal with due to the sheer number of similar subject emails. 

Thanks

Liam
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

