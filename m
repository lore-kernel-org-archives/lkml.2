Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101Ab0IQNsv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 09:48:51 -0400
Received: from hera.kernel.org ([140.211.167.34]:33826 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752159Ab0IQNsu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 09:48:50 -0400
Message-ID: <4C937177.1090909@kernel.org>
Date: Fri, 17 Sep 2010 15:47:35 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Peter Palfrader <peter@palfrader.org>, stable@kernel.org,
        Huang Shijie <shijie8@gmail.com>, akpm@linux-foundation.org,
        linux-mm@kvack.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [stable] breaks 2.6.32.21+
References: <1281261197-8816-1-git-send-email-shijie8@gmail.com> <4C5EA651.7080009@kernel.org> <20100916213603.GW6447@anguilla.noreply.org> <20100916231307.GB24617@kroah.com>
In-Reply-To: <20100916231307.GB24617@kroah.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 17 Sep 2010 13:47:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2010 01:13 AM, Greg KH wrote:
> Odd, someone just reported the same problem for .35-stable as well.
> 
> Tejun, what's going on here?

Please drop it.  The memory leak was introduced after 2.6.36-rc1.  I
got confused which commit was in which kernel.  I'll be more careful
with stable cc's.  Sorry about that.

-- 
tejun
