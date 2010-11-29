Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408Ab0K2AYk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 19:24:40 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44794 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754303Ab0K2AYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 19:24:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=LRAlBSf4HlO6LIYAdKcmJ+Scd5mDgJ0UPmJrjNIT/YNcfYDqmLnuyiV1p1rIxtm/fc
         YiphdDUmlzDSsYMNYkJFpjfGx5SLwTrP4CBzUBbUIKAlySe9EeRipdn6Do4LeyiX3kpA
         VBnRE4YIUWUOEzSIHQhlJisBzUcoClw27Tm9Y=
MIME-Version: 1.0
In-Reply-To: <1290754316.25125.2.camel@mola>
References: <1290754245.25125.1.camel@mola>
	<1290754316.25125.2.camel@mola>
Date: Sun, 28 Nov 2010 22:24:38 -0200
Message-ID: <AANLkTinZeSjJ2RKmZ4L7eXZrsTQvE_2AZ3WmNXD8+t75@mail.gmail.com>
Subject: Re: [PATCH 1/4] ASoC: Fix resource leask in goni_wm8994.c
From: Thiago Farina <tfransosi@gmail.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Jassi Brar <jassi.brar@samsung.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a typo in the subject.

leask -> leak

no?
