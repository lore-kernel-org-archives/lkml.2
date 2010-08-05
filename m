Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214Ab0HEEf0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 00:35:26 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44052 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881Ab0HEEfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 00:35:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ac4WQzUlhUj2CmthSyy5niRrBQjwJ2CBZaPr28yp+xrqA9a+ZPFGcGhOXKyE6AWZcX
         0ULBPdCih7tlUVTalE7OkNRqn/BtZdO2UltisGB9BKtfuqSbhMilfdcP+GpzzpkXNY4e
         qilYFXE3gL89bDoLhZbp01TAnCjjz8In3siRw=
Subject: Re: [PATCH] gen_nand: Fix support for multiple chips
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Marek Vasut <marek.vasut@gmail.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        hsweeten@visionengravers.com, dwmw2@infradead.org
In-Reply-To: <1280295414-3354-1-git-send-email-marek.vasut@gmail.com>
References: <1280295414-3354-1-git-send-email-marek.vasut@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 Aug 2010 07:35:18 +0300
Message-Id: <1280982918.4363.19.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-07-28 at 07:36 +0200, Marek Vasut wrote:
> This patch corrects a problem where gen_nand driver assumed there can be only
> one chip and ignored the pdata->chip.nr_chips value.
> 
> Signed-off-by: Marek Vasut <marek.vasut@gmail.com>

Pushed to my l2-mtd-2.6.git / master

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

