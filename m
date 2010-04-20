Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434Ab0DTFR1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 01:17:27 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:35219 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753278Ab0DTFR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 01:17:26 -0400
Date: Tue, 20 Apr 2010 07:17:16 +0200
From: Pavel Machek <pavel@ucw.cz>
To: skitching@apache.org
Cc: jkt@gentoo.org, linux-kernel@vger.kernel.org
Subject: Re: boot device order troubleshooting without an initrd
Message-ID: <20100420051716.GB2075@ucw.cz>
References: <20100418165125.1d2b2843@infradead.org>
 <1271672423.005324.28333.nullmailer@xnet.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271672423.005324.28333.nullmailer@xnet.co.nz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2010-04-19 22:20:23, skitching@apache.org wrote:
> As it happens, I've been looking into this issue recently.
> [Warning: kernel newbie speaking!]
> 
> Without an initrd, the options for the root= kernel parameters are only those supported in init/do_mount.c:
>   1.   root=MAJOR:MINOR
>   2.   root=integer   where integer is MAJOR<<n + minor
>   3    root=/dev/xxx
> (well, apart fron "mtd" and "ubi" options).

And nfs?

> Unfortunately, all of these options are sensitive to hardware changes, ie device enumeration order. So I 
> think that right now the answer to your question is: no, you can't get what you want without an initrd.
> 
> And I doubt that changes to the linux device-enumeration code "to be consistent with the BIOS" would be accepted.
>

If it is clean enough... why not?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
