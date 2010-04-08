Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751474Ab0DHEKj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 00:10:39 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:34119 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981Ab0DHEKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 00:10:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=EqkRuWtmfl2G0atq1kfGjRjmgtlUSkSYZpinZJ0svq+1+fwGmOXiOvT0mAqICb+/aU
         Qdz9AZ2+8TMHzrmouHKpw9Hsu+BdNPgYrLLREJNlKou2/60+y6k6uDtstXvgwF39uLNB
         08NY3HP6TnKqfxy+1idxtWWdv9FyXlrb5QCxY=
Date: Thu, 8 Apr 2010 12:14:16 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Ryan Wang <openspace.wang@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: BUG? boot failed with "crashkernel=256M@32M", but
 "crashkernel=256M@64M" can work
Message-ID: <20100408041416.GB3978@cr0.nay.redhat.com>
References: <h2k5d592f661004072058hcdac7ab5y3eceeaab28f6fbe0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <h2k5d592f661004072058hcdac7ab5y3eceeaab28f6fbe0@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 08, 2010 at 11:58:17AM +0800, Ryan Wang wrote:
>Hi all,
>
>        I have setup kdump on my box, but failed on booting with
>                       "crashkernel=256M@32M".
>Then I tried
>                       "crashkernel=256M@64M"
>and succeeded.
>
>       Is it a bug of kernel?

It could be.

What failure did you meet? And your boot log?

Also, which version are you using?

Thanks.
