Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752305Ab1EABVs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 21:21:48 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:63939 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083Ab1EABVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 21:21:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=d888MX+fl+luzxT+tsB77cWAUei5U4bC65H44KcxL5tlSBz0kDNHanVDh1291X7inp
         y/phqj22xmruGI5LYDkIpTY8iiet+OrWccbu+wI6yUJR/ekwmHYAyNfKOQpipLlZdqTu
         N6XJDlLGiDoq3IkEPWb9UaniuBviV0mnyw2ik=
Date: Sun, 1 May 2011 09:21:30 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, greg@kroah.com,
        randy.dunlap@oracle.com, joe@perches.com
Subject: Re: [Oops 1/2]Something wrong with copy_from_user() function
Message-ID: <20110501012127.GA2378@gmail.com>
Mail-Followup-To: Jiri Kosina <jkosina@suse.cz>,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	greg@kroah.com, randy.dunlap@oracle.com, joe@perches.com
References: <20110430061336.GA4274@gmail.com>
 <alpine.LNX.2.00.1104302311530.12035@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1104302311530.12035@pobox.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 30, 2011 at 11:13:10PM +0200, Jiri Kosina wrote:
> On Sat, 30 Apr 2011, Harry Wei wrote:
> 
> 
> wpa_set_keys() function (from staging drivers) in your kernel uses 
> copy_from_user() without proper bounds checking, and thus can overflow and 
> corrupt memory.
Hmmm, i see.

Thanks.
Harry Wei.
> 
