Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933075Ab0FEVUI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 17:20:08 -0400
Received: from mail-ew0-f223.google.com ([209.85.219.223]:41219 "EHLO
	mail-ew0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932702Ab0FEVUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 17:20:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=nsQldzLxf5A7Bi9UvMd2BVHGu/DYOWyyRqKUjYvY3nWRTpZw9B4Pem8GmrrDbR+CSi
         cr1j17dOoce2aXKznhg6bhwj3dMtH5vjNy+CjlqWtgsyvkNZ7cqYA2ytxWlHdGVjnqYS
         GM7gkkb5KmZUHp0nPAqp//4g6cCJWnpGUFRGg=
Date: Sat, 5 Jun 2010 23:19:43 +0200
From: Dan Carpenter <error27@gmail.com>
To: Richard Weinberger <richard@nod.at>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
       rakib.mullick@gmail.com, ebiederm@xmission.com, gorcunov@openvz.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] APIC: Remove unused variable
Message-ID: <20100605211943.GN5483@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Richard Weinberger <richard@nod.at>, tglx@linutronix.de,
	mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
	rakib.mullick@gmail.com, ebiederm@xmission.com, gorcunov@openvz.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <1275771369-15113-1-git-send-email-richard@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275771369-15113-1-git-send-email-richard@nod.at>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 05, 2010 at 10:56:09PM +0200, Richard Weinberger wrote:
> base is never used in this file.
> 

This is left over from commit 7b20bd5fb9 "x86, irq: Kill 
io_apic_renumber_irq" where we removed the es7000_rename_gsi() function.
Could you remove the comment that went with it as well?

/* 
 * GSI override for ES7000 platforms.
 */

regards,
dan carpenter


