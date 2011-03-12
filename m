Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797Ab1CLRYE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 12:24:04 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62477 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754304Ab1CLRYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 12:24:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ovHjGrT28yQrVdu1wW7V3E1esryC54rr5qG6BC+e6FvnXFiLbyJA5zL58pPQG2/E9q
         oeVI95reV1EzCxBApX1ck/qhF1GO9/SCQhnpZUHji/BSy7CQsp4/y1/6yNp/zSQUDuq6
         TtYfmEsr0gs70Xecsz+ODTTRWH4gAsyaJTFL8=
Date: Sat, 12 Mar 2011 18:23:49 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Torben Hohn <torbenh@gmx.de>, linux-kernel@vger.kernel.org,
        richard.cochran@omicron.at, johnstul@us.ibm.com
Subject: Re: [PATCH 3/3] Check for write permission on FD based posix-clocks
Message-ID: <20110312172349.GB3048@riccoc20.at.omicron.at>
References: <1299173174-348-1-git-send-email-torbenh@gmx.de>
 <1299173174-348-4-git-send-email-torbenh@gmx.de>
 <20110304072239.GA8957@riccoc20.at.omicron.at>
 <alpine.LFD.2.00.1103112044410.2787@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1103112044410.2787@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 11, 2011 at 08:46:57PM +0100, Thomas Gleixner wrote:
> As Arnd already said -EACCES is sensible for file permission checks
> while -EPERM means that you have no permission at all.

Okay, so you will accept Torben's patch as is, into timers/core?

Thanks,

Richard
