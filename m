Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453Ab2GTVcg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 17:32:36 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:41906 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111Ab2GTVcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 17:32:35 -0400
Message-ID: <5009CE6E.4080006@suse.cz>
Date: Fri, 20 Jul 2012 23:32:30 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120626 Thunderbird/15.0a2
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Dan Carpenter <dan.carpenter@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] tty: handle NULL parameters in free_tty_struct()
References: <20120720070634.GC11710@elgon.mountain> <20120720104831.47cb4237@pyramind.ukuu.org.uk>
In-Reply-To: <20120720104831.47cb4237@pyramind.ukuu.org.uk>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20/2012 11:48 AM, Alan Cox wrote:
> On Fri, 20 Jul 2012 10:06:34 +0300
> Dan Carpenter <dan.carpenter@oracle.com> wrote:
> 
>> We sometimes pass NULL pointers to free_tty_struct().  One example where
>> it can happen is in the error handling code in pty_common_install().
>>
>> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> Acked-by: Alan Cox <alan@linux.intel.com>
> 
> We probably shouldn't be passing NULLs there but making
> free_tty_struct(NULL) a no-op matches the kfree and other behaviours and
> is robust.

Yes, this was unintended. Good catch, Dan.

thanks,
-- 
js
suse labs
