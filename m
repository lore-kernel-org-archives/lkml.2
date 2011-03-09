Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932811Ab1CIRhR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 12:37:17 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42332 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932275Ab1CIRhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 12:37:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=HpP0UKeWGMkLQe8QFS3mNnUMdkmI1NonPE21dgbz7ax5HN0orx2vDxSmVoVpKmL6LL
         9xdWBTj6fkl4XjjHpBovJbjY5qAepes9AO7GpbJYkKh22gYxYOCd8UCDyYqmSqDhDbNQ
         asBQ918hcYlrJcwlZLWbmUZvFwnZ6oOWXlGMg=
Date: Wed, 9 Mar 2011 20:36:28 +0300
From: Dan Carpenter <error27@gmail.com>
To: Vinay Sawal <vinaysawal@gmail.com>
Cc: greg@kroah.com, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Staging: bcm: Bcmnet: fixed 'checkpatch.pl' issues
Message-ID: <20110309173628.GG3416@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Vinay Sawal <vinaysawal@gmail.com>, greg@kroah.com,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
References: <1299653902-27644-1-git-send-email-vinaysawal@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299653902-27644-1-git-send-email-vinaysawal@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 08, 2011 at 10:58:22PM -0800, Vinay Sawal wrote:
> Fixed all issues reported by 'checkpatch.pl' for this file.
> 
> Signed-off-by: Vinay Sawal <vinaysawal@gmail.com>
> ---
> +
> +#define __NO_VERSION__

What do these __NO_VERSION__ defines do?

>  #include "headers.h"

regards,
dan carpenter
