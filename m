Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306Ab2HNCa7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 22:30:59 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:35549 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754760Ab2HNCaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 22:30:07 -0400
Date: Mon, 13 Aug 2012 19:30:02 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Devendra Naga <develkernel412222@gmail.com>
Cc: Javier =?iso-8859-1?Q?Mu=F1oz?= <jmunhoz@igalia.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Devendra Naga <devendra.aaru@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] staging: sm7xxfb: copy name of the device before
 calling smtc_alloc_fb_info
Message-ID: <20120814023002.GA1046@kroah.com>
References: <1344101120-22866-1-git-send-email-develkernel412222@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344101120-22866-1-git-send-email-develkernel412222@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 04, 2012 at 11:10:20PM +0545, Devendra Naga wrote:
> as we do a strcpy(smdrv_ptr->fb_struct->fix->id, name), and the name here in
> sm7xxx_probe is not having any assignment, and which leads to copying of the garbage value
> into the id field of the fix struct of fb interface struct. fix it by copying the name before
> calling alloc_fbinfo.
> 
> Signed-off-by: Devendra Naga <develkernel412222@gmail.com>
> ---
> 
> Changes since V1:
>  Fix a null deref when smtc_alloc_fbinfo fails, this was added by me in V1.

Huh?  Please resend the correct patch you want me to apply, I'm confused
here.

greg k-h
