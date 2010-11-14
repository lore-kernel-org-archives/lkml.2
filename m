Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932262Ab0KNU3i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 15:29:38 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47687 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932178Ab0KNU3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 15:29:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=vDfWw8tnOEXUJSeJ/BZX84FAOC+Bd2YD9C4vIwINUrAQM/uzJfXZn4uQoqOiV2greE
         suf6gTPpFaXrN9zEDzL6imiZuUqn5NppRmZv4XKcgC42dmwvbob7yynnABzyrwPwGfUM
         tPJrhpzNQy5hq9WVby10+vaS+6cSOrs7B6KSY=
Date: Sun, 14 Nov 2010 23:29:05 +0300
From: Dan Carpenter <error27@gmail.com>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: kernel-janitors@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: jffs2: fix error value sign
Message-ID: <20101114202905.GA21614@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Vasiliy Kulikov <segoon@openwall.com>,
	kernel-janitors@vger.kernel.org,
	David Woodhouse <dwmw2@infradead.org>,
	linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1289765320-6071-1-git-send-email-segoon@openwall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289765320-6071-1-git-send-email-segoon@openwall.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 14, 2010 at 11:08:39PM +0300, Vasiliy Kulikov wrote:
> do_verify_xattr_datum(), do_load_xattr_datum(), load_xattr_datum()
> and verify_xattr_ref() should return negative value on error.
> Sometimes they return EIO that is positive.  Change this to -EIO.
> 
> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
> ---
>  This driver is not compilable, so the patch is not tested.
> 

It compiles.

regards,
dan carpenter


