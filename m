Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510Ab1JGVVM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 17:21:12 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:55131 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751209Ab1JGVVH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 17:21:07 -0400
Message-ID: <1318022466.11045.18.camel@Joe-Laptop>
Subject: Re: [PATCH 05/26] dynamic_debug: pr_err() call should not depend
 upon verbosity
From: Joe Perches <joe@perches.com>
To: jim.cromie@gmail.com
Cc: jbaron@redhat.com, greg@kroah.com, bart.vanassche@gmail.com,
        linux-kernel@vger.kernel.org
Date: Fri, 07 Oct 2011 14:21:06 -0700
In-Reply-To: <1318019612-20068-6-git-send-email-jim.cromie@gmail.com>
References: <1316642115-20029-1-git-send-email-jim.cromie@gmail.com>
	 <1318019612-20068-1-git-send-email-jim.cromie@gmail.com>
	 <1318019612-20068-6-git-send-email-jim.cromie@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-10-07 at 14:33 -0600, jim.cromie@gmail.com wrote:
> Also convert to pr_err(), which supplies __func__ via pr_fmt.

Just a note on the changelog.
The original code already uses pr_err.

> diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
[]
> @@ -334,8 +334,7 @@ static int ddebug_parse_query(char *words[], int nwords,
>  				query->last_lineno = query->first_lineno;
>  			}
>  		} else {
> -			if (verbose)
> -				pr_err("unknown keyword \"%s\"\n", words[i]);
> +			pr_err("unknown keyword \"%s\"\n", words[i]);


