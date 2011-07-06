Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986Ab1GFTfF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 15:35:05 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:53912 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755906Ab1GFTfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 15:35:02 -0400
Date: Wed, 6 Jul 2011 23:34:57 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: "Lin, Tommy" <Tommy.Lin@caviumnetworks.com>
Cc: Tommy Lin <tommy.lin.1101@gmail.com>, Wim Van Sebroeck <wim@iguana.be>,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Lin, Mac" <Mac.Lin@caviumnetworks.com>
Subject: Re: [PATCH 2/2] watchdog: mpcore_wdt Add reload value setting for
 CNS3xxx hardware
Message-ID: <20110706193457.GA20378@oksana.dev.rtsoft.ru>
References: <1309867548-7842-1-git-send-email-tommy.lin@caviumnetworks.com>
 <20110705140559.GA15771@oksana.dev.rtsoft.ru>
 <281B1F8BAB4D4BDABE7568809A0AEC1A@starsemi.com>
 <20110706111616.GA18967@oksana.dev.rtsoft.ru>
 <20110706112830.GA23184@oksana.dev.rtsoft.ru>
 <20110706114629.GA32659@oksana.dev.rtsoft.ru>
 <6D7FCE1DF69D524D850E799960F2705811271D@caexch01.caveonetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <6D7FCE1DF69D524D850E799960F2705811271D@caexch01.caveonetworks.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 06, 2011 at 07:54:49AM -0700, Lin, Tommy wrote:
> I am thinking that mpcore_wdt should work even SMP is not turned on. Did the dependency 
> is neccesarry between mpcore_wdt and SMP? If CPU1 is turned off the mpcore_wdt worked
> well with CPU0 only.

No doubt that the watchdog itself works fine. :-) But the point is
that the patch yields a warning, so it should be fixed before merging.

Thanks,

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
