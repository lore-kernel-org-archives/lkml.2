Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359Ab2EMT5m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 15:57:42 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:39131 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275Ab2EMT5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 15:57:39 -0400
Message-ID: <4FB0122E.4000603@suse.cz>
Date: Sun, 13 May 2012 21:57:34 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120508 Thunderbird/14.0a2
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Jiri Slaby <jirislaby@gmail.com>, stable@vger.kernel.org,
        linux-pm <linux-pm@lists.linux-foundation.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        "sedat.dilek@gmail.com" <sedat.dilek@gmail.com>,
        alexander.deucher@amd.com
Subject: Re: 3.3.5 regression: resume doesn't switch to X
References: <4FAE0E88.2030703@suse.cz> <20120512154307.GA6023@kroah.com>
In-Reply-To: <20120512154307.GA6023@kroah.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/2012 05:43 PM, Greg KH wrote:
> On Sat, May 12, 2012 at 09:17:28AM +0200, Jiri Slaby wrote:
>> Hi,
> 
> <side note, it's stable@vger.kernel.org, not stable@kernel.org>

Ah, fixed. Why it didn't bounce? Is it silently dropped?

>> since update to 3.3.5, my X doesn't show up after resume from
>> hibernation anymore. The only thing I see is "resuming..." on the
>> console. I can switch to any tty and login in text mode, but cannot
>> switch to X despite it is running. I have to restart whole session to
>> have X again.
>>
>> Now I'm back to 3.3.4 and everything is OK.
> 
> Care to run 'git bisect' to find the offending patch?

Hmm, I cannot reproduce. I booted 3.3.5 twice and X did not show up
after resume. Then I booted 3.3.4 and it worked. Now 3.3.5 works too...
So maybe this is uptime related or I hit some race twice in a row?

Anyway now I'm running 3.3.5 and the problem have not recurred yet...

thanks,
-- 
js
suse labs

