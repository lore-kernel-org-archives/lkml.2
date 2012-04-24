Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195Ab2DXQQH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 12:16:07 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:54119 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755613Ab2DXQQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 12:16:05 -0400
Message-ID: <4F96D1C1.7060701@wwwdotorg.org>
Date: Tue, 24 Apr 2012 10:16:01 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Gerard Snitselaar <dev@snitselaar.org>
CC: sameo@linux.intel.com, ldewangan@nvidia.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd/tps65910: fix section mismatch in linux-next
References: <1335280435-2457-1-git-send-email-dev@snitselaar.org>
In-Reply-To: <1335280435-2457-1-git-send-email-dev@snitselaar.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2012 09:13 AM, Gerard Snitselaar wrote:
> tps65910_i2c_probe() calls tps65910_sleepinit() which is annnotated __init.

> -static int tps65910_i2c_probe(struct i2c_client *i2c,
> +static int __init tps65910_i2c_probe(struct i2c_client *i2c,

Shouldn't this be __devinit not __init?
