Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758834Ab2HISJg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 14:09:36 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:40730 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505Ab2HISJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 14:09:34 -0400
Message-ID: <5023FCDB.4080607@wwwdotorg.org>
Date: Thu, 09 Aug 2012 12:09:31 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Laxman Dewangan <ldewangan@nvidia.com>, lrg@ti.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: tps6586x: correct vin pin for sm0/sm1/sm2
References: <1343117880-11576-1-git-send-email-ldewangan@nvidia.com> <5022E0B0.1070406@wwwdotorg.org> <20120809180514.GZ24328@opensource.wolfsonmicro.com>
In-Reply-To: <20120809180514.GZ24328@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2012 12:05 PM, Mark Brown wrote:
> On Wed, Aug 08, 2012 at 03:57:04PM -0600, Stephen Warren wrote:
> 
>> I assume that was just an accident?
> 
> Probably.  I suspect a conflict with mainline when I rebased onto
> v3.6-rc1.  Please resend the patch, I don't think I have it any more.

The patch in question just showed up again in next-20120809:

7f852e0 regulator: tps6586x: correct vin pin for sm0/sm1/sm2

... with the exact same content as the previous commit ID.
