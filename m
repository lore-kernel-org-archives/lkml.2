Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902Ab2L1Q5i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 11:57:38 -0500
Received: from de01.mail.all-tld.net ([195.140.232.8]:49571 "EHLO
	de01.mail.all-tld.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753693Ab2L1Q5g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 11:57:36 -0500
X-Greylist: delayed 1100 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Dec 2012 11:57:36 EST
Date: Fri, 28 Dec 2012 17:39:08 +0100
From: Anders Larsen <al@alarsen.net>
Subject: Re: [PATCH] [trivial]treewide: Fix typo in various drivers
To: Masanari Iida <standby24x7@gmail.com>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org
References: <1356709778-6933-1-git-send-email-standby24x7@gmail.com>
In-Reply-To: <1356709778-6933-1-git-send-email-standby24x7@gmail.com> (from
	standby24x7@gmail.com on Fri Dec 28 16:49:38 2012)
X-Mailer: Balsa 2.4.1
Message-Id: <1356712748.4121.5@oscar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-ALL-TLD-GmbH-Information: AEV Virus and Spam Secure Mail System
X-ALL-TLD-GmbH-VirusScanner: Found to be clean
X-ALL-TLD-GmbH-SpamCheck: 
X-MailScanner-From: al@alarsen.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-12-28 16:49, Masanari Iida wrote:
> Correct spelling typo in printk within various drivers.
> ---
> diff --git a/net/caif/cfcnfg.c b/net/caif/cfcnfg.c
> index ba9cfd4..8d0fe66 100644
> --- a/net/caif/cfcnfg.c
> +++ b/net/caif/cfcnfg.c
> @@ -402,7 +402,7 @@ cfcnfg_linkup_rsp(struct cflayer *layer, u8  
> channel_id, enum cfctrl_srv serv,
> 
>  	phyinfo = cfcnfg_get_phyinfo_rcu(cnfg, phyid);
>  	if (phyinfo == NULL) {
> -		pr_err("ERROR: Link Layer Device dissapeared"
> +		pr_err("ERROR: Link Layer Device dissappeared"

that should rather be
+		pr_err("ERROR: Link Layer Device disappeared"

>  				"while connecting\n");
>  		goto unlock;
>  	}

Cheers
Anders
