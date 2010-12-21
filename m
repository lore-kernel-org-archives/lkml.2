Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513Ab0LUW1r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 17:27:47 -0500
Received: from mail-ey0-f171.google.com ([209.85.215.171]:52995 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391Ab0LUW1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 17:27:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=nTFWcJWnKhq3VQv2wwo76HlYotntuhS/Prb8xTBiZBR91BTh8CAtw9qOYovm+XPexB
         V2vI6lSL4poXVBi097XlMLW6DzvWH6SyI7xdqpS1Pf0uHb+9bTSYTNxLgAYj6AowWbce
         nkoXgbD+2Y/U40SdAv4PHGlpsmCAauLJ7NB8o=
From: Vasily Khoruzhick <anarsoul@gmail.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Subject: Re: [PATCH] s3c_adc_battery: Add gpio_inverted field to pdata
Date: Wed, 22 Dec 2010 00:26:44 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-gentoo-r3-anarsoul; KDE/4.5.4; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <1292235981-9842-1-git-send-email-anarsoul@gmail.com>
In-Reply-To: <1292235981-9842-1-git-send-email-anarsoul@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201012220026.44737.anarsoul@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 13 December 2010 12:26:21 Vasily Khoruzhick wrote:
> Add support for inverted gpio_charge_finished values.
> This change is necessary for H1940 support.

Ping?
