Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756683Ab0LIKnu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 05:43:50 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:34350 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756033Ab0LIKns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 05:43:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=DmWbZIM6vFAuC2mhVmzU4KeGmsSxKalW5QodgLxj5VxuZVv+U6qWvc6gH6DdeQ3mtk
         jWYTT3SMX1iYa2eVeu/Rdi5Us1e1FKD3AUTmYBdJOzeRl27OXA6f9U0oPHKjJoZufETc
         O4MZtY/kRTZH5t+D6JmcoD9yykE8DOGyq0aKE=
Date: Thu, 9 Dec 2010 13:43:36 +0300
From: Dan Carpenter <error27@gmail.com>
To: Marek Belisko <marek.belisko@open-nandra.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] staging: ft1000: Convert char device to debugfs.
Message-ID: <20101209104336.GT10623@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Marek Belisko <marek.belisko@open-nandra.com>,
	Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
References: <1291890413-15255-1-git-send-email-marek.belisko@open-nandra.com>
 <1291890413-15255-2-git-send-email-marek.belisko@open-nandra.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291890413-15255-2-git-send-email-marek.belisko@open-nandra.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +	file = debugfs_create_file("device", S_IRUGO | S_IWUGO, dir,
                                                       ^^^^^^^
> +					NULL, &ft1000fops);

Don't make this world writeable.

regards,
dan carpenter

