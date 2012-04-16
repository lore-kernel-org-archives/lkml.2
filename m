Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754971Ab2DPRsI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 13:48:08 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:30689 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869Ab2DPRsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 13:48:05 -0400
Date: Mon, 16 Apr 2012 20:50:29 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, lacombar@gmail.com
Subject: Re: [PATCH v2]NEXT:drivers:staging:rtl8187se Fix typos in
 staging:rtl8187se
Message-ID: <20120416175029.GF6498@mwanda>
References: <1334589703-15707-1-git-send-email-justinmattock@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334589703-15707-1-git-send-email-justinmattock@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4F8C5B52.00C1,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2012 at 08:21:43AM -0700, Justin P. Mattock wrote:
> From: "Justin P. Mattock" <Justin P. Mattock>
> 
> RESEND: resending this patch because my email was mangled with gitconfig.
> The below patch fixes some typos that I found while reading. 
> 

It's still messed up as pants.  Here is what it looks like when you
do a `cat email.txt | git am ; git log`

commit c8cc1d3bc3e18d92ce14fa233008d299c1d7355a
Author: Justin P. Mattock <Justin P. Mattock>
Date:   Mon Apr 16 08:21:43 2012 -0700

    NEXT:drivers:staging:rtl8187se Fix typos in staging:rtl8187se
    
    RESEND: resending this patch because my email was mangled with gitconfig.
    The below patch fixes some typos that I found while reading.
    
    Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

Your email address is screwed up.

Put the NEXT inside the square brackets with the [patch], but
actually you can just leave it out because everything should apply
to -next.  This clearly isn't a critical bugfix.

The subject prefix should be:  "Staging: rtl8187se:"  Do a "git log
--pretty=oneline " to find this.  Put the commentry the doesn't
belong in the log under the --- line with the diffstat.

regards,
dan carpenter

