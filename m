Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805Ab1CAW6K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 17:58:10 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51621 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756753Ab1CAW6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 17:58:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qq0vaNz4CTEoWYJ+gkojtgkUxQcFUMkkKssvAN0yUVsM/r9csG0sKvylh/jehtjSNI
         vSbSZ2eH8jlxCYnGR2/bRpS27LOBF/BdQ3DPnRX91ofZD3Z1xgBbYDreWeiUmD5+qj+N
         ewFDQ5OefyJM7/XSZljvwb3u8ZdoIRHHI5KAQ=
Date: Wed, 2 Mar 2011 01:58:03 +0300
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Andres Salomon <dilinger@queued.net>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] jz4740: silence warnings related to mfd_get_cell
 changes
Message-ID: <20110301225803.GA4881@oksana.dev.rtsoft.ru>
References: <20110301133548.6acb5170@debxo>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110301133548.6acb5170@debxo>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 01, 2011 at 01:35:48PM -0800, Andres Salomon wrote:
> 
> mfd_get_cell returns a const, so change the jz4740 clients to store
> a const mfd cell.  This silences type mismatch warnings.
> 
> Signed-off-by: Andres Salomon <dilinger@queued.net>
> ---
>  drivers/hwmon/jz4740-hwmon.c   |    2 +-
>  drivers/power/jz4740-battery.c |    2 +-

For the drivers/power/ part:

Acked-by: Anton Vorontsov <cbouatmailru@gmail.com>

Thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
