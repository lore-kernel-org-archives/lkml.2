Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761410Ab2BNXxR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 18:53:17 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:39241 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757276Ab2BNXxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 18:53:16 -0500
X-Sasl-enc: C5ncEBdQLhqZiAd8Ew78oAr7SCLwpnvxd89A6wzWvfaE 1329263595
Date: Tue, 14 Feb 2012 21:53:13 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Bill Nottingham <notting@redhat.com>
Cc: linux-kernel@vger.kernel.org, ibm-acpi-devel@lists.sourceforge.net
Subject: Re: [ibm-acpi-devel] [PATCH] Make 'Thermal Table has changed' a
 debug message.
Message-ID: <20120214235313.GD9521@khazad-dum.debian.net>
References: <1329247829-28099-1-git-send-email-notting@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329247829-28099-1-git-send-email-notting@redhat.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Feb 2012, Bill Nottingham wrote:
> If the recommended action is "do nothing", we shouldn't be cluttering
> the logs with it.
> 
> Signed-off-by: Bill Nottingham <notting@redhat.com>
Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

We never figured out what interesting hint the thinkpad was trying to give
us.

> diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
> index ea0c607..a96983e 100644
> --- a/drivers/platform/x86/thinkpad_acpi.c
> +++ b/drivers/platform/x86/thinkpad_acpi.c
> @@ -3605,7 +3605,7 @@ static bool hotkey_notify_6xxx(const u32 hkey,
>  
>  	switch (hkey) {
>  	case TP_HKEY_EV_THM_TABLE_CHANGED:
> -		pr_info("EC reports that Thermal Table has changed\n");
> +		pr_debug("EC reports that Thermal Table has changed\n");
>  		/* recommended action: do nothing, we don't have
>  		 * Lenovo ATM information */
>  		return true;

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
