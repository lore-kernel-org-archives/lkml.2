Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294Ab1L0KGe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 05:06:34 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:65427 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631Ab1L0KGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 05:06:32 -0500
Message-ID: <4EF998A3.4070403@linaro.org>
Date: Tue, 27 Dec 2011 18:06:27 +0800
From: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111114 Icedove/3.1.16
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        patches@linaro.org
Subject: Re: [PATCHv2] Regulator: Add Anatop regulator driver
References: <1323265998-29088-2-git-send-email-paul.liu@linaro.org> <1324458211-1612-1-git-send-email-paul.liu@linaro.org> <20111222113337.GL4546@opensource.wolfsonmicro.com>
In-Reply-To: <20111222113337.GL4546@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011年12月22日 19:33), Mark Brown wrote:
> 
>> +#include <linux/platform_device.h>
>> +#include <linux/regulator/machine.h>
> 
> Why does your regulator driver need this?  That suggests a layering
> violation.
> 

Sorry, I'm not sure what does this mean.
But if I want to access regulator_constraints, shouldn't I include this
header file?

Yours Sincerely,
Paul

