Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618Ab0L1JNy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 04:13:54 -0500
Received: from smtp.nokia.com ([147.243.128.24]:32431 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751588Ab0L1JNv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 04:13:51 -0500
Message-ID: <4D19AB5C.3000608@nokia.com>
Date: Tue, 28 Dec 2010 11:18:20 +0200
From: Peter Ujfalusi <peter.ujfalusi@nokia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101215 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: ext Stephen Rothwell <sfr@canb.auug.org.au>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warning after merge of the sound-asoc tree
References: <20101228103234.29e09106.sfr@canb.auug.org.au>
In-Reply-To: <20101228103234.29e09106.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 12/28/2010 01:32 AM, ext Stephen Rothwell wrote:
> Hi all,
> 
> After merging the sound-asoc tree, today's linux-next build (x86_64
> allmodconfig) produced this warning:
> 
> sound/soc/codecs/tpa6130a2.c: In function 'tpa6130a2_add_controls':
> sound/soc/codecs/tpa6130a2.c:342: warning: unused variable 'dapm'
> 
> Introduced by commit 39646871a47fd8808c08de0ce7d7ca8393af2805 ("ASoC:
> tpa6130a2: Replace DAPM code with direct interface").

Sorry about that.
I'll send the fix in a few minutes.

-- 
Péter
