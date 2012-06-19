Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727Ab2FSACX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 20:02:23 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53518 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753482Ab2FSACV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 20:02:21 -0400
Date: Mon, 18 Jun 2012 17:02:18 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Devendra Naga <devendra.aaru@gmail.com>
Cc: "Justin P. Mattock" <justinmattock@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] staging/rtl8182u: cleanup eprom_read function and
 clean all checkpatch warnings / errors
Message-ID: <20120619000218.GB4208@kroah.com>
References: <1339940911-20648-1-git-send-email-devendra.aaru@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339940911-20648-1-git-send-email-devendra.aaru@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 17, 2012 at 07:18:31PM +0530, Devendra Naga wrote:
> this patch cleans up the copying of the addr data into addr_str fields
> by using for loops.
> 
> and also with the previous patch all the checkpatch warnings / errors are
> eliminated

Please only do one thing per patch, so break this up into a few
different ones.

thanks,

greg k-h
