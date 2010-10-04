Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755639Ab0JDMW5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 08:22:57 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40128 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755342Ab0JDMWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 08:22:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=bSqCNi2hknb2bRjTXm18AHFzy5rjVykVTRoPgfozVHSaA/3VsSIVTMpmdfxYFywex+
         RWEjqxA0qJXuHVM0rHzE76C8AoBISIh4CVuPszWpORUlZHNVmgzzJaN13n78ZSxR45qb
         OJtTFSkQUkg/b7ZIAppvHk1rIMr2nP2fK8NnQ=
Date: Mon, 4 Oct 2010 14:22:14 +0200
From: Dan Carpenter <error27@gmail.com>
To: Rahul Ruikar <rahul.ruikar@gmail.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, nm127@freemail.hu,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RESEND/PATCH] usb: gadget: goku_udc: Fix error path
Message-ID: <20101004122214.GA5692@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Rahul Ruikar <rahul.ruikar@gmail.com>,
	David Brownell <dbrownell@users.sourceforge.net>,
	Greg Kroah-Hartman <gregkh@suse.de>, nm127@freemail.hu,
	linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1286135940-2364-1-git-send-email-rahul.ruikar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286135940-2364-1-git-send-email-rahul.ruikar@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 04, 2010 at 01:29:00AM +0530, Rahul Ruikar wrote:
> call put_device() when device_register() fails.
> 

Sorry I didn't realize what you were trying to do here.  This is not
correct at all.

The right thing is to fix device_register() to call put_device() itself.
It's a bit involved, because all the callers will need to be audited but
someone is working on this I think.

regards,
dan carpenter

