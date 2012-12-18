Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081Ab2LRWLD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 17:11:03 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:53757 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755489Ab2LRWK7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 17:10:59 -0500
Message-ID: <1355868659.3982.3.camel@joe-AO722>
Subject: Re: [PATCH 2/2] MCE, AMD: MCE decoding support for AMD Family 16h
From: Joe Perches <joe@perches.com>
To: Jacob Shin <jacob.shin@amd.com>
Cc: Borislav Petkov <bp@alien8.de>, Doug Thompson <dougthompson@xmission.com>,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 18 Dec 2012 14:10:59 -0800
In-Reply-To: <1355864771-13839-3-git-send-email-jacob.shin@amd.com>
References: <1355864771-13839-1-git-send-email-jacob.shin@amd.com>
	 <1355864771-13839-3-git-send-email-jacob.shin@amd.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-12-18 at 15:06 -0600, Jacob Shin wrote:
> Add MCE decoding logic for AMD Family 16h processors.

More trivia:

> diff --git a/drivers/edac/mce_amd.c b/drivers/edac/mce_amd.c
[]
> @@ -64,6 +64,10 @@ EXPORT_SYMBOL_GPL(to_msgs);
>  const char * const ii_msgs[] = { "MEM", "RESV", "IO", "GEN" };
>  EXPORT_SYMBOL_GPL(ii_msgs);
>  
> +/* internal error type */
> +const char * const uu_msgs[] = { "RESV", "RESV", "HWA", "RESV" };
> +EXPORT_SYMBOL_GPL(uu_msgs);

Do these really need to be exported?
These don't seem to be used outside of mce_amd.

If these really need export, are these very good names?
Perhaps these should be prefixed with something?


