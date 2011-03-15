Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758020Ab1COOvL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 10:51:11 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:39579 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412Ab1COOvK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 10:51:10 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTikwjRgCB8nnkTeZq+AbjQ+ugQz_WMshEFMSFo=_@mail.gmail.com>
References: <1297827283-22860-1-git-send-email-bibek.basu@stericsson.com>
	<1297827283-22860-2-git-send-email-bibek.basu@stericsson.com>
	<AANLkTi=Yv1fHVTC-BVBJ3WRPGOmOC3fCJ13G-dCegLYo@mail.gmail.com>
	<AANLkTi=qN=i3VW=VXPQ1PAFTXFgo3O_jqykTkc7A7JLF@mail.gmail.com>
	<AANLkTi=o8CbHjJHZETokQP8bz5SyLnyLLadM4UMyZc=6@mail.gmail.com>
	<AANLkTinU7g4qLVwLwFXyt_j6tmGq-5MC9a-wy_cGvC9Y@mail.gmail.com>
	<AANLkTikwjRgCB8nnkTeZq+AbjQ+ugQz_WMshEFMSFo=_@mail.gmail.com>
Date: Tue, 15 Mar 2011 15:51:09 +0100
Message-ID: <AANLkTikw87uS4w15ZWZOp8bUU1jYwn1xK4tp5cSrpeYH@mail.gmail.com>
Subject: Re: [PATCH] AB8500 GPIO : Driver for 42 AB8500 GPIO pins
From: Linus Walleij <linus.walleij@linaro.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Bibek BASU <bibek.basu@stericsson.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 15, 2011 at 3:33 PM, Grant Likely <grant.likely@secretlab.ca> wrote:

> Ping me *after* Russell's tree gets merged and I'll pick it up.  I
> don't want to mess about with apply-order breakage.

This driver does not depend on anything from Russells tree
or any other tree for that matter... It's a clean merge.

Linus Walleij
