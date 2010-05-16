Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500Ab0EPNMv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 09:12:51 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44206 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752348Ab0EPNMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 09:12:49 -0400
Date: Sun, 16 May 2010 14:19:17 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Florian Fainelli <florian@openwrt.org>
Cc: mingo@elte.hu, "linux-kernel" <linux-kernel@vger.kernel.org>,
       andi@firstfloor.org
Subject: Re: [PATCH] x86: CPU detection for RDC System-on-Chip
Message-ID: <20100516141917.0d2e69e2@lxorguk.ukuu.org.uk>
In-Reply-To: <201005161455.34100.florian@openwrt.org>
References: <201005161455.34100.florian@openwrt.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +	case 0x00321004:  /* tested */
> +		strcpy(c->x86_model_id, "S3282/CodeTek");
> +		break;
> +	case 0x00321007:
> +		strcpy(c->x86_model_id, "R8610");
> +		break;
> +	default:
> +		pr_info("RDC CPU: Unrecognised Customer ID (0x%x) please "
> +			"report to: linux-kernel@vger.kernel.org\n",
> +			customer_id);

Surely this should be a break as you want to set the vendor. You've
established its an RDC at this point have you not - so you want to set
x86_vendor.

Alan
