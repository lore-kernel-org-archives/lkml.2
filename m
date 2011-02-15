Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883Ab1BOCpv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 21:45:51 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:34123 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800Ab1BOCpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 21:45:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:x-mutt-references:in-reply-to:mime-version:x-mutt-fcc
         :content-type:content-transfer-encoding:content-disposition:cc
         :message-id:x-mailer:from:subject:x-apple-content-length:date:to;
        b=a3exZlMPvuWLMabQ4F8rb9J09VVxNnoLuEHizkYrcuEMyLfdr85teb/dKeJ8h7jIrV
         UT/LszcVxvHPAjm+d6/iNrRP2sDgXVokRCXVlh8rOBTcrlyqRe82alkHlFqSIqdFgm7X
         Ks3Q/oICHPoJ7fu9B9Yr8nY7Xf5iStL0Yq5GI=
References: <20110211204653.9A32D9D401D@zog.reactivated.net>
X-Mutt-References: <20110211204653.9A32D9D401D@zog.reactivated.net>
In-Reply-To: <20110211204653.9A32D9D401D@zog.reactivated.net>
Mime-Version: 1.0
X-Mutt-Fcc: =sent-mail
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Cc: "cbou@mail.ru" <cbou@mail.ru>, "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "dilinger@queued.net" <dilinger@queued.net>
Message-Id: <B3A1DFAA-AC7A-44ED-AC43-BC244B04E34C@gmail.com>
X-Mailer: iPhone Mail (8B117)
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH] olpc_battery: convert to platform device
X-Apple-Content-Length: 369
Date: Mon, 14 Feb 2011 18:45:25 -0800
To: Daniel Drake <dsd@laptop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On Fri, Feb 11, 2011 at 08:46:53PM +0000, Daniel Drake wrote:
> +}
> +
> +static struct platform_driver olpc_battery_drv = {
> +    .driver = {
> +        .name = "olpc-battery",

Since driver name does not match exactly with the module name don't you
need MODULE_ALIAS("platform:olpc-battery") to automatically load the
driver?

Thanks.

-- 
Dmitry
