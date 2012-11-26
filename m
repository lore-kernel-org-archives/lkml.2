Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952Ab2KZDXm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2012 22:23:42 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:42957 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753816Ab2KZDXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2012 22:23:41 -0500
Message-ID: <50B2E0D9.1050000@linaro.org>
Date: Mon, 26 Nov 2012 08:54:09 +0530
From: Tushar Behera <tushar.behera@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        patches@opensource.wolfsonmicro.com, patches@linaro.org
Subject: Re: [PATCH 00/10] ASoC: codec: devm_ related modifications
References: <1353557322-25353-1-git-send-email-tushar.behera@linaro.org> <20121123143710.GQ4529@opensource.wolfsonmicro.com>
In-Reply-To: <20121123143710.GQ4529@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23/2012 08:07 PM, Mark Brown wrote:
> On Thu, Nov 22, 2012 at 09:38:32AM +0530, Tushar Behera wrote:
>> This patchset includes devm_ related modifications for sound codecs.
>>
>> First 2 patches fix warning for freeing of devm_ allocated data.
>> The next patch introduces usage of devm_kzalloc() in wm8995 codec.
>> Following 7 patches introduce usage of devm_regmap_init_xxx() in
>> remaining codecs.
> 
> Applied all, thanks.  If you're doing stuff like this it's helpful to
> sort by part.
> 
Thanks. I will keep that in mind.

-- 
Tushar Behera
