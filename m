Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273Ab2KFWF6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 17:05:58 -0500
Received: from smtp110.biz.mail.ne1.yahoo.com ([98.138.206.47]:21263 "HELO
	smtp110.biz.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752253Ab2KFWF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 17:05:56 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: Kh_RKH4VM1mqmdqkyA9k7cP_0VdHjY_ZvJFw3nwcRfbSbnw
 F.FdJkq.nUa.k.jsj8imrrV5qIaqwGSosUAZxK3kd98MFSrYS_ahK..7XN8C
 cU7mh7oiyXAz7tKW.10f3L.Cq7KN2e2ND0fXvW1SGmptkLOnCkTm0yKRgfuI
 quqtKbPVyAibGG4RJc1vGvYcrpmtTaEm7l1Z4i2.4OW7.6nxNFCS_3rXTel8
 4ip1vEBlD5JjZefe9lZE9oud4dJBvpMj7wL05RwmSjNlNaPXxsbWQbXmpOT2
 jZlDgqmEJ5opNKGFD_JVU6H6Hkuk3wLO7IUiOuE7U7uQSdPozIPDkturD_Lf
 lzm3JNHG24z3G9Twqa6pJmI2XcMRLWvrw9ntsUOzfmpZOURKixoyPTR5wmbe
 ibpBRI4o1yDonduI.WAuqF4mnnFIajjyrQ84iwkhvggO7tQRTgFwElykUMkK
 jNzwh_yJS
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <50998834.5030407@schaufler-ca.com>
Date: Tue, 06 Nov 2012 13:59:16 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Jarkko Sakkinen <jarkko.sakkinen@iki.fi>
CC: James Morris <james.l.morris@oracle.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH] smack: SMACK_MAGIC to include/uapi/linux/magic.h
References: <y> <1352189869-27190-1-git-send-email-jarkko.sakkinen@iki.fi>
In-Reply-To: <1352189869-27190-1-git-send-email-jarkko.sakkinen@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/6/2012 12:17 AM, Jarkko Sakkinen wrote:
> SMACK_MAGIC moved to a proper place for easy user space access
> (i.e. libsmack).
>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@iki.fi>
> ---
>  include/uapi/linux/magic.h |    1 +
>  security/smack/smack.h     |    5 -----
>  2 files changed, 1 insertion(+), 5 deletions(-)

Will security/smack/smack_lsm.c and security/smack/smackfs.c
compile after this change?

>
> diff --git a/include/uapi/linux/magic.h b/include/uapi/linux/magic.h
> index e15192c..12735ad 100644
> --- a/include/uapi/linux/magic.h
> +++ b/include/uapi/linux/magic.h
> @@ -11,6 +11,7 @@
>  #define DEBUGFS_MAGIC          0x64626720
>  #define SECURITYFS_MAGIC	0x73636673
>  #define SELINUX_MAGIC		0xf97cff8c
> +#define SMACK_MAGIC		0x43415d53	/* "SMAC" */
>  #define RAMFS_MAGIC		0x858458f6	/* some random number */
>  #define TMPFS_MAGIC		0x01021994
>  #define HUGETLBFS_MAGIC 	0x958458f6	/* some random number */
> diff --git a/security/smack/smack.h b/security/smack/smack.h
> index 99b3612..8ad3095 100644
> --- a/security/smack/smack.h
> +++ b/security/smack/smack.h
> @@ -149,11 +149,6 @@ struct smack_known {
>  #define SMACK_CIPSO_SOCKET	1
>  
>  /*
> - * smackfs magic number
> - */
> -#define SMACK_MAGIC	0x43415d53 /* "SMAC" */
> -
> -/*
>   * CIPSO defaults.
>   */
>  #define SMACK_CIPSO_DOI_DEFAULT		3	/* Historical */

