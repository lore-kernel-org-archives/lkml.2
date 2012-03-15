Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761795Ab2COQyh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 12:54:37 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:64573 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753782Ab2COQyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 12:54:35 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1
Date: Thu, 15 Mar 2012 17:54:33 +0100
From: Karol Lewandowski <k.lewandowsk@samsung.com>
Subject: Re: [PATCH 2/3] i2c-s3c2410: Rework device type handling
In-reply-to: <20120315125630.GK3138@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: ben-linux@fluff.org, thomas.abraham@linaro.org, m.szyprowski@samsung.com,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-samsung-soc@vger.kernel.org,
        t.stanislaws@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <4F621EC9.6020106@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111109 Icedove/8.0
References: <1331657679-31302-1-git-send-email-k.lewandowsk@samsung.com>
 <1331657679-31302-3-git-send-email-k.lewandowsk@samsung.com>
 <20120314172915.GB13393@sirena.org.uk> <4F61BEC8.4030008@samsung.com>
 <20120315125630.GK3138@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15.03.2012 13:56, Mark Brown wrote:

> On Thu, Mar 15, 2012 at 11:04:56AM +0100, Karol Lewandowski wrote:
> 
>> Introducing separate type (TYPE_S3C2440_HDMIPHY) has been our original
>> attempt to solve this issue.  However, this required adding explicit
>> checks to driver code all over the place (if (type == S3C2400 ||
>> type == S3c2440_HDMIPHY).
> 
> Another option is to change the type to be a pointer to a struct with
> quirk flags in it.


Sure, that's possible.   However, I don't find it any simpler than
using  bitmasks.  Quite to contrary - I consider it redundant to
bring new structure into existence when simple uint does the trick
just fine (IMHO, of course).

If you consider code to be inherently less readable because of this
approach I'll rework it.  If it's not a such big deal for you I would
prefer to keep it as is.

Thanks!
-- 
Karol Lewandowski | Samsung Poland R&D Center | Linux/Platform
