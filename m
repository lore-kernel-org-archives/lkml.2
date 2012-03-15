Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031903Ab2COQse (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 12:48:34 -0400
Received: from smtp-out-226.synserver.de ([212.40.185.226]:1075 "EHLO
	smtp-out-226.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031769Ab2COQsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 12:48:30 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 8912
Message-ID: <4F621DDE.8010603@metafoo.de>
Date: Thu, 15 Mar 2012 17:50:38 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111114 Iceowl/1.0b2 Icedove/3.1.16
MIME-Version: 1.0
To: Ashish Jangam <ashish.jangam@kpitcummins.com>
CC: rpurdie@rpsys.net, linux-kernel@vger.kernel.org,
        David Dajun Chen <Dajun.Chen@diasemi.com>
Subject: Re: [PATCH] LEDS: LED module for DA9052/53 PMIC v2
References: <1329916149.24042.7.camel@dhruva> <1331641560.7058.1.camel@dhruva>
In-Reply-To: <1331641560.7058.1.camel@dhruva>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2012 01:26 PM, Ashish Jangam wrote:
> Any update on below patch?

The patch itself looks good to me. But if David is the author as the C file
states he should also be the autor of the git commit. You can change the
author of the git commit for example by running `git commit --amend --author
'David Dajun Chen <dchen@diasemi.com>'`.

You should send the patch to Andrew Morten since he takes care of merging
led patches these days.

> On Wed, 2012-02-22 at 18:39 +0530, Ashish Jangam wrote:
>> LED Driver for Dialog Semiconductor DA9052/53 PMICs.
>>
>> Signed-off-by: David Dajun Chen <dchen@diasemi.com>
>> Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>\

Reviewed-by: Lars-Peter Clausen <lars@metafoo.de>
