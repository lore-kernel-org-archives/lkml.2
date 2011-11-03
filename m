Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934545Ab1KCT0f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 15:26:35 -0400
Received: from vps.mortis.eu ([79.99.135.181]:40401 "EHLO vps.mortis.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934458Ab1KCT0d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 15:26:33 -0400
X-Greylist: delayed 636 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Nov 2011 15:26:33 EDT
Date: Thu, 3 Nov 2011 20:15:55 +0100
From: Giel van Schijndel <me@mortis.eu>
To: Xin Tong <xerox.time.tech@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Undefined Instruction
Message-ID: <20111103191555.GC7197@vps.mortis.eu>
References: <CALKntY3zkAHc92_6Sk2Mg06J6N1RCj38O7AQk0a5d6pCtivD-Q@mail.gmail.com>
 <alpine.LRH.2.00.1111022205100.17927@twin.jikos.cz>
 <CALKntY1S9HCQkqVBQSJLUO=L=DfwaSuN4m=akJBKuQ2dxBj4MQ@mail.gmail.com>
 <alpine.LNX.2.00.1111022209560.348@pobox.suse.cz>
 <CALKntY2yJm1Usi60dbZo-8OmfpfZp4AELFbw7QH5QsgvjFLdCQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALKntY2yJm1Usi60dbZo-8OmfpfZp4AELFbw7QH5QsgvjFLdCQ@mail.gmail.com>
OpenPGP: id=CEE5E742; url=http://gpg.mortis.eu/me.asc
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 02, 2011 at 05:14:17PM -0400, Xin Tong wrote:
> On Wed, Nov 2, 2011 at 5:10 PM, Jiri Kosina <jkosina@suse.cz> wrote:
>> On Wed, 2 Nov 2011, Xin Tong wrote:
>>
>>> If i change the kernel, i could have the application stary alive
>>> right?
>>
>> No need for any kernel changes. You can set your own signal handler
>> for SIGILL (but iirc that will make any further behavior of your
>> application undefined as long as POSIX is involved).
> 
> There must be a default handler install for every application on
> linux, right  ? Is there any signal that the operating system simply
> kills the programs without sending a signal to the user level ?

It's known by the rather straightforward name of SIGKILL. I.e. userland
cannot install a signal handler for that signal, the process just gets
killed.

-- 
Met vriendelijke groet,
With kind regards,
Giel van Schijndel
