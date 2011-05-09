Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243Ab1EIQBz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 12:01:55 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44312 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780Ab1EIQBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 12:01:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=kqBaYdvuUpipWPjxky4B4glvp4urLTv0xym8aiIvtB2zy1ifJsIBUJNYE+ARRQfANv
         wCkQaSSdxqM489xYF0Jg2Os/L3KZlZoZyTB6lch2qMedfEoQY4d1XRmf4TXaASKRgKMX
         ERmgKjgXmT/jWa+EMzPtbCo81md2mUSV339oM=
Subject: Re: [PATCH] regulator: Convert WM8400 to get_voltage_sel()
From: Liam Girdwood <lrg@kernel.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1304889549-15490-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1304889549-15490-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 May 2011 17:01:49 +0100
Message-ID: <1304956909.3192.17.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-05-08 at 22:19 +0100, Mark Brown wrote:
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/regulator/wm8400-regulator.c |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)
> 


Applied.

Thanks

Liam

