Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751973Ab1AOAXj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 19:23:39 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42557 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130Ab1AOAXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 19:23:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=hq6tsaIaB83lP01QL3dVEzKHxA8O7dbU1kf8cY7KnrCVKbMbA1S9yDcXTj34AA9ONG
         DV3aw46uBhdRdbxkwcP8hZhggzaFDGmsR/GCupCBahL/YOACdGw5iHTjyT+RTMIrV6Z1
         KMrqMe45aaPUgiduQ3XQjQW/FGI5W8IaTDPu0=
MIME-Version: 1.0
In-Reply-To: <1294827494-15092-2-git-send-email-s.hauer@pengutronix.de>
References: <1294827494-15092-1-git-send-email-s.hauer@pengutronix.de>
	<1294827494-15092-2-git-send-email-s.hauer@pengutronix.de>
Date: Fri, 14 Jan 2011 16:23:36 -0800
X-Google-Sender-Auth: CDsVAorSQOV0kVU6G6tL0l-Cv98
Message-ID: <AANLkTi=zi1uLm4w-=rBmLseWf0GD6kJJHngD8Shpacar@mail.gmail.com>
Subject: Re: [PATCH] dmaengine i.MX SDMA: Fix firmware loading
From: Dan Williams <dan.j.williams@intel.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 12, 2011 at 2:18 AM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> When loading the microcode to the SDMA engine we have to use
> the ram_code_start_addr found in the firmware image. The copy
> in the sdma engine is not initialized correctly. This is broken
> since:
> 5b28aa3 dmaengine i.MX SDMA: Allow to run without firmware
>
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> ---

I'll apply this to my 'fixes' branch once I rebase on top of rc1.

--
Dan
