Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755774Ab3AFCph (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 21:45:37 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:42387 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755168Ab3AFCpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 21:45:35 -0500
Date: Sat, 5 Jan 2013 18:42:03 -0800
From: Anton Vorontsov <anton@enomsg.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org, patches@linaro.org
Subject: Re: [PATCH 0/3] power: bq2415x_charger: Some cleanup
Message-ID: <20130106024203.GB6919@lizard.sbx05280.losalca.wayport.net>
References: <1353995926-4621-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1353995926-4621-1-git-send-email-sachin.kamat@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2012 at 11:28:43AM +0530, Sachin Kamat wrote:
> This series is build tested againt the linux-next tree (20121126)
> 
> Sachin Kamat (3):
>   power: bq2415x_charger: Remove unneeded version.h inclusion
>   power: bq2415x_charger: Use module_i2c_driver
>   power: bq2415x_charger: Use devm_kzalloc()

Applied, thanks a lot!
