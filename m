Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791Ab0IMSMj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 14:12:39 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:65282 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753699Ab0IMSMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 14:12:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=lS+gFBwfipgX/fcBY35QtsMtUjmXCsbctyZqtOmM3631ZaBIVi65UI2cqEHl5ZpSL7
         Y30yH54DWR7OM8WwBqvxamnmt/GJtHGPreiH4fy66Cj30xqcAuhnxLLDRHnnwqBr+p9U
         +W1pZjhm8oyFWuKEMLCdd4x2KEPd97eS1/GNw=
Message-ID: <4C8E6992.1010902@suse.cz>
Date: Mon, 13 Sep 2010 20:12:34 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.8) Gecko/20100802 SUSE/3.1.2 Thunderbird/3.1.2
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org,
        lwn@lwn.net, Alan Stern <stern@rowland.harvard.edu>,
        Phil Dibowitz <phil@ipom.com>
Subject: Re: Linux 2.6.34.7
References: <20100913170515.GA8943@kroah.com> <AANLkTinA30LGPUMrL_5tLaB+rLUAv7AAutZwiZCW2qJJ@mail.gmail.com>
In-Reply-To: <AANLkTinA30LGPUMrL_5tLaB+rLUAv7AAutZwiZCW2qJJ@mail.gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2010 07:41 PM, Linus Torvalds wrote:
> On Mon, Sep 13, 2010 at 10:05 AM, Greg KH <gregkh@suse.de> wrote:
>>
>> It fixes a single bug that a number of users have reported in that their
>> USB devices no longer work properly.  Sometimes it causes lost
>> keystrokes, and other times X refuses to boot as it can not communicate
>> properly with some tablet devices.
> 
> So just out of interest, why is that commit ok and doesn't need to be
> reverted in 36-rc? The comments in the commit message do not explain.

Please see:
http://lkml.org/lkml/2010/9/13/272

thanks,
-- 
js
suse labs
