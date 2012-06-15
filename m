Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757862Ab2FOV3Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 17:29:25 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44772 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884Ab2FOV3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 17:29:23 -0400
Date: Fri, 15 Jun 2012 14:29:18 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        James.Bottomley@hansenpartnership.com, mdharm-usb@one-eyed-alien.net,
        stern@rowland.harvard.edu, sshtylyov@mvista.com, bvanassche@acm.org
Subject: Re: [PATCH v4 0/3] scsi: fix internal write cache issue on usb hdd.
Message-ID: <20120615212918.GB23338@kroah.com>
References: <1339601248-3251-1-git-send-email-linkinjeon@gmail.com>
 <CAKYAXd9sbVL9Ut4nZOg5Mt3ZuCOouUq64d-ifjtbO0TnaU1XvA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKYAXd9sbVL9Ut4nZOg5Mt3ZuCOouUq64d-ifjtbO0TnaU1XvA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A: No.
Q: Should I include quotations after my reply?

http://daringfireball.net/2007/07/on_top

On Fri, Jun 15, 2012 at 12:51:58PM +0900, Namjae Jeon wrote:
> Hi Greg.
> 
> Would you check this patch-set ?


I can't do much about scsi core patches, sorry.  If James acks them, I
can take them through my tree.

thanks,

greg k-h
