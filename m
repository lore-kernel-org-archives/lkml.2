Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947Ab2CII3v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 03:29:51 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:56819 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753533Ab2CII3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 03:29:49 -0500
Message-ID: <4F59BE04.5030509@suse.cz>
Date: Fri, 09 Mar 2012 09:23:32 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120229 Thunderbird/11.0
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: Ben Hutchings <ben@decadent.org.uk>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        Tony Luck <tony.luck@intel.com>, Jiri Slaby <jirislaby@gmail.com>,
        raven@themaw.net
Subject: Re: Build broken on s390 and ia64 [was: Linux 2.6.32.58]
References: <20120304180911.GA7336@kroah.com> <4F54A46A.6000305@suse.cz> <20120305120241.GA3627@osiris.boeblingen.de.ibm.com> <4F54B618.1090301@suse.cz> <20120305223338.GE2930@1wt.eu> <1331270953.3022.89.camel@deadeye> <20120309065703.GE25153@1wt.eu>
In-Reply-To: <20120309065703.GE25153@1wt.eu>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/2012 07:57 AM, Willy Tarreau wrote:
> Thanks but now I have a doubt, maybe Jiri and Tony can help. In the
> commit above, Tony says that CONFIG_COMPAT has been broken for a long
> time (2008) and nobody apparently uses it. Still, Jiri got a build
> failure because he used CONFIG_COMPAT. So either there are some valid
> uses and we should not remove the feature that late in a stable branch,
> or Jiri only encountered it upon a make allyesconfig then it might
> be safe to remove it.

It's a SLE11-SP1 that is using the kernel and has COMPAT on ia64
enabled. I don't know if it is broken or if we provide support for that.

If you are sure COMPAT is broken on ia64 even in 2.6.32, feel free to
ban COMPAT completely.

thanks,
-- 
js
suse labs
