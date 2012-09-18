Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932295Ab2IRHaY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 03:30:24 -0400
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:43807 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932122Ab2IRHaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 03:30:23 -0400
Message-ID: <5058233F.8000904@ti.com>
Date: Tue, 18 Sep 2012 10:31:11 +0300
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120917 Thunderbird/15.0.1
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Samuel Ortiz <sameo@linux.intel.com>, NeilBrown <neilb@suse.de>,
        Benoit Cousson <b-cousson@ti.com>, Felipe Balbi <balbi@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mfd: twl: Replace twl_has_*() macros by IS_ENABLED()
References: <1346582458-7890-1-git-send-email-thierry.reding@avionic-design.de> <1346582458-7890-2-git-send-email-thierry.reding@avionic-design.de>
In-Reply-To: <1346582458-7890-2-git-send-email-thierry.reding@avionic-design.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/2012 01:40 PM, Thierry Reding wrote:
> Instead of reinventing macros for the same purpose, use the standard
> macros.
> 
> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>

Acked-by: Peter Ujfalusi <peter.ujfalusi@ti.com>

