Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755727Ab0GaTSl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 15:18:41 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41154 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754790Ab0GaTSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 15:18:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=WrZfj/HTuzdnX26J65HY1SwiheD42D3NgD43DrKTghmG4T4EoPZDWYFSXp1/sNBTDq
         txvqfRdOAPAfndpvNWsTU9lc1aSfIKF+FrB6nn7aTf4hfokHGq0MLKkVuqITz/sHw68D
         yQTw0aqCSoOjMIjw7QG60clbH52YtdlJe+OaU=
Date: Sat, 31 Jul 2010 21:17:43 +0200
From: Dan Carpenter <error27@gmail.com>
To: Kulikov Vasiliy <segooon@gmail.com>
Cc: kernel-janitors@vger.kernel.org, Li Yang <leoli@freescale.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Dinh Nguyen <Dinh.Nguyen@freescale.com>,
        Anton Vorontsov <avorontsov@ru.mvista.com>, linux-usb@vger.kernel.org,
        linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] usb: fsl_udc_core: check return value of
	create_proc_read_entry()
Message-ID: <20100731191743.GF26313@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Kulikov Vasiliy <segooon@gmail.com>,
	kernel-janitors@vger.kernel.org, Li Yang <leoli@freescale.com>,
	David Brownell <dbrownell@users.sourceforge.net>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Dinh Nguyen <Dinh.Nguyen@freescale.com>,
	Anton Vorontsov <avorontsov@ru.mvista.com>,
	linux-usb@vger.kernel.org, linuxppc-dev@ozlabs.org,
	linux-kernel@vger.kernel.org
References: <1280597900-8405-1-git-send-email-segooon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280597900-8405-1-git-send-email-segooon@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 31, 2010 at 09:38:20PM +0400, Kulikov Vasiliy wrote:
> create_proc_read_entry() may fail, if so return -ENOMEM.
> 

It can fail, but also we return NULL if procfs is disabled.  I haven't
looked at it very carefully, would this patch break the module if procfs
was disabled?

The same applies to the similar patches in this set.

regards,
dan carpenter


