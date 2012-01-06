Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030257Ab2AFBN6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 20:13:58 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:43302 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932443Ab2AFBN4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 20:13:56 -0500
MIME-Version: 1.0
In-Reply-To: <4F063B75.8020207@lwfinger.net>
References: <1325796541-11402-1-git-send-email-festevam@gmail.com>
	<4F0635FE.6050507@xenotime.net>
	<4F063B75.8020207@lwfinger.net>
Date: Thu, 5 Jan 2012 23:13:55 -0200
Message-ID: <CAOMZO5ADu=FAzB7s9cK2LMcWb8JqupjfV6wDEcGu_kfGT93nyQ@mail.gmail.com>
Subject: Re: [PATCH] drivers: misc: Remove MISC_DEVICES config option
From: Fabio Estevam <festevam@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Randy Dunlap <rdunlap@xenotime.net>, netdev@vger.kernel.org,
        gwingerde@gmail.com, davem@davemloft.net, bhutchings@solarflare.com,
        greg@kroah.com, arnd@arndb.de, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 5, 2012 at 10:08 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> Fabio,
>
> Does this patch fix your problem?

It will fix this specific EEPROM_93CX6 issue, but I recall seeing
other similar cases of build warnings related to the missing
dependency of MISC_DEVICES. I can´t provide any other examples until
Tuesday next week.

Instead of fixing each instance where this MISC_DEPENDENCY issue
happens, I think that removing MISC_DEVICES could be a good fix.

Regards,

Fabio Estevam
