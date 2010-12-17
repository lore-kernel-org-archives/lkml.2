Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994Ab0LQLGX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 06:06:23 -0500
Received: from hera.kernel.org ([140.211.167.34]:49369 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776Ab0LQLGW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 06:06:22 -0500
Message-ID: <4D0B43DE.7050407@kernel.org>
Date: Fri, 17 Dec 2010 12:05:02 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Duncan Sands <duncan.sands@free.fr>, linux-usb@vger.kernel.org
Subject: Re: [PATCH 5/6] speedtch: don't abuse struct delayed_work
References: <1292172499-21633-1-git-send-email-tj@kernel.org> <1292172499-21633-6-git-send-email-tj@kernel.org> <20101216213005.GA5781@kroah.com>
In-Reply-To: <20101216213005.GA5781@kroah.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 17 Dec 2010 11:05:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 12/16/2010 10:30 PM, Greg KH wrote:
> You forgot to add a "Signed-off-by:" on these patches, so I can't take
> them in my tree :(

Oops, sorry about that.  Where did they go?  :-)

> But feel free to add:
> 	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> to both 5/6 and 6/6 of this series and take them through your tree.

Yeap, will do so.

Thanks.

-- 
tejun
