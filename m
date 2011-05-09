Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320Ab1EIQCI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 12:02:08 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:35023 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257Ab1EIQCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 12:02:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Ax7zZVELPq3lVLbsWH55Tpim6Dxy3LMtjuAs4Jq/PCZ/9b5qfe8z83r25D1cGpy6/9
         n8WwEqfZn1qCJQImE9tfWWeiwBnvpdDOYDK89hAlPq9NoOBy6vTIkdIZ4/ACMf43KoxO
         Bxb08EC8plwzibmVADCGGpySzNV8HQoOQF8JM=
Subject: Re: [PATCH] regulator: Remove supply_regulator_dev from machine
 configuration
From: Liam Girdwood <lrg@kernel.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonicro.com
In-Reply-To: <1304890218-19332-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1304890218-19332-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 May 2011 17:02:02 +0100
Message-ID: <1304956922.3192.18.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-05-08 at 22:30 +0100, Mark Brown wrote:
> supply_regulator_dev (using a struct pointer) has been deprecated in favour
> of supply_regulator (using a regulator name) for quite a few releases
> now with a warning generated if it is used and there are no current in tree
> users so just remove the code.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---


Applied.

Thanks

Liam

