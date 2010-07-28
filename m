Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013Ab0G1SCR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 14:02:17 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:46930 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598Ab0G1SCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 14:02:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=oyC5CWgVH4VMcEj9VqIkBBJXDAauuRoaqvkQMSNFHnpxm82Dft76p6tbmIHkjtcDZ1
         PxZkWB3FhUU2f8D8nmYvYx4Eo7fBAUHk412hGVPEZGB4rHdtUctpp4z63W6qVwprw6bO
         5zsXDZU2thx+kR/sR9cHTkzwssFB/0kODtnqM=
Date: Wed, 28 Jul 2010 20:01:38 +0200
From: Dan Carpenter <error27@gmail.com>
To: Kulikov Vasiliy <segooon@gmail.com>
Cc: kernel-janitors@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/10] arm: leds: check return value of request_region()
Message-ID: <20100728180138.GO26313@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Kulikov Vasiliy <segooon@gmail.com>,
	kernel-janitors@vger.kernel.org,
	Russell King <linux@arm.linux.org.uk>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1280335127-23145-1-git-send-email-segooon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280335127-23145-1-git-send-email-segooon@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 28, 2010 at 08:38:47PM +0400, Kulikov Vasiliy wrote:
> request_region() may fail, if so return -ENOMEM.

I think -EBUSY is more normal, although some people return -ENODEV or
-EIO.  But I would think -EBUSY is the right one.

regards,
dan carpenter


