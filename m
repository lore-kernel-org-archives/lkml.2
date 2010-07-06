Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210Ab0GFI7X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 04:59:23 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41852 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682Ab0GFI7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 04:59:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=pNCXLqW68pcI+I2XgOnM5iSkT/d+GL+aD8SYS97rKk6yZmOZVo6Wz7kPJxDNp9Nf1B
         HdyPO/DHxon/uZRHBGpn9IE0lq+Ab2rCYN4fSJqu4lMrLFfZ37GRdvPOTo1KRxeJE6/W
         wh/jFzY8+hEO/Q5yY2NRCocLJ3LjmkFQkgXt4=
Message-ID: <4C32F052.6060202@gmail.com>
Date: Tue, 06 Jul 2010 10:58:58 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.4) Gecko/20100608 SUSE/3.1.0 Thunderbird/3.1
MIME-Version: 1.0
To: kagen101@gmail.com
CC: Greg Kroah-Hartman <gregkh@suse.de>,
       H Hartley Sweeten <hsweeten@visionengravers.com>,
       Simon Horman <horms@verge.net.au>, devel <devel@driverdev.osuosl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] Staging: dt3155: fix coding style issues in dt3155_drv.c
References: <1278367345.5396.64.camel@dermezel>
In-Reply-To: <1278367345.5396.64.camel@dermezel>
X-Enigmail-Version: 1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/06/2010 12:02 AM, Joe Eloff wrote:
> --- a/drivers/staging/dt3155/dt3155_drv.c
> +++ b/drivers/staging/dt3155/dt3155_drv.c
> @@ -78,7 +78,7 @@ extern void printques(int);
>  MODULE_LICENSE("GPL");
>  
>  /* Error variable.  Zero means no error. */
> -int dt3155_errno = 0;
> +int dt3155_errno ;

Isn't this a checkpatch error :)?

-- 
js
