Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877Ab0F2M7H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 08:59:07 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64019 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754560Ab0F2M7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 08:59:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=CqJm43arUt2ZZCZkJtqtHi7YTCMbBpzGlaLQIxLNbUVdx1C2zll/0a14bLf815ZLpG
         FCKt1VNkb4lSMq7ns7vmveXU7aXTVGg/kV+NRq3jm6z7shnM/g6GwPLTzx0RaCCViZTt
         oSn5+m+Dapvm79O3+A2eFYnV2GcJJ8wXG0qhc=
Date: Tue, 29 Jun 2010 16:59:01 +0400
From: Kulikov Vasiliy <segooon@gmail.com>
To: Nicolas Palix <npalix@diku.dk>, k@shinshilla
Cc: trivial@kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
       Julia Lawall <julia@diku.dk>, Michal Marek <mmarek@suse.cz>,
       linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH] Documentation: fix ubuntu distro name
Message-ID: <20100629125858.GA2279@shinshilla>
References: <1277814677-1944-1-git-send-email-segooon@gmail.com>
 <201006291447.16073.npalix@diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201006291447.16073.npalix@diku.dk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 29, 2010 at 14:47 +0200, Nicolas Palix wrote:
> Hi Kulikov,
> 
> Indeed. I mixed things.
> 
> But Coccinelle was already in Karmic [1].
> Can you submit a patch with 9.10 instead of 10.04 ?
> 
> I will Ack it.
> 
> Thanks.
> 
> [1] https://launchpad.net/ubuntu/+source/coccinelle

As you see in [1], coccinelle version in Karmic is 0.1.9.
I don't know if it is buggy for linux.

In documentation it is 0.2.0:
> Coccinelle (>=0.2.0) is available through the package manager
> of many distributions, e.g. :
> 
>  - Debian (>=squeeze)
>  - Fedora (>=13)
>  - Ubuntu (>=10.04 Lucid Lynx)
>  - OpenSUSE
>  - Arch Linux
>  - NetBSD
>  - FreeBSD

So, if 0.1.9 is OK, I can make smth like this: 
>  - Ubuntu (>=9.04 Karmic Koala, coccinelle = 0.1.9)
