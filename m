Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757529Ab2CAAXE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 19:23:04 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:36007 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755846Ab2CAAXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 19:23:02 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.195.71 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
Date: Wed, 29 Feb 2012 15:56:19 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: trivial@vger.kernel, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, jic23@cam.ac.uk
Subject: Re: [PATCH]drivers:staging:iio Fix typos and comments in staging iio.
Message-ID: <20120229235619.GA26970@kroah.com>
References: <1330356363-3208-1-git-send-email-justinmattock@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330356363-3208-1-git-send-email-justinmattock@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 27, 2012 at 07:26:03AM -0800, Justin P. Mattock wrote:
> From: "Justin P. Mattock" <justinmattock@gmail.com>
> 
> The below patch fixes some comments and some typos that I have found
> while reading drivers/staging/iio/*
> 
> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

This patch doesn't apply to my tree, care to redo it against the next
linux-next release and resend it?

thanks,

greg k-h
