Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760624Ab2IGNvn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 09:51:43 -0400
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:48215 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755245Ab2IGNvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 09:51:41 -0400
Message-ID: <5049FC05.6090101@ti.com>
Date: Fri, 07 Sep 2012 16:52:05 +0300
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120903 Thunderbird/15.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Samuel Ortiz <sameo@linux.intel.com>, NeilBrown <neilb@suse.de>,
        Benoit Cousson <b-cousson@ti.com>, Felipe Balbi <balbi@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] mfd: twl: Move PWM driver to PWM framework
References: <1346582458-7890-1-git-send-email-thierry.reding@avionic-design.de> <5044664C.5010508@ti.com> <20120907131926.GF29340@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20120907131926.GF29340@avionic-0098.mockup.avionic-design.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/2012 04:19 PM, Thierry Reding wrote:
>> All looks good for me but I have one comment for patch 2.
> 
> Okay. With that change to patch 2, can I add your Acked-by?

Yes, with that change added:

Acked-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
