Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751966Ab2AOTCC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 14:02:02 -0500
Received: from hades.mikemestnik.net ([184.106.158.151]:53607 "EHLO
	hades.mikemestnik.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451Ab2AOTCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 14:02:00 -0500
Message-ID: <4F1322A6.7090009@mikemestnik.net>
Date: Sun, 15 Jan 2012 13:01:58 -0600
From: Mike Mestnik <cheako@mikemestnik.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0) Gecko/20111223 Thunderbird/10.0
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: Chronic resource starvation.
References: <4F10F3AE.3030801@mikemestnik.net>  <4F11E3B8.6090007@mikemestnik.net> <1326629295.6352.14.camel@marge.simson.net>
In-Reply-To: <1326629295.6352.14.camel@marge.simson.net>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/12 06:08, Mike Galbraith wrote:
> On Sat, 2012-01-14 at 14:21 -0600, Mike Mestnik wrote:
>> On 01/13/12 21:17, Mike Mestnik wrote:
>>> I've dealt with applications taking extended time off for a number of
>>> years.  I typically attribute it to applications being overly zealous
>>> about eating memory as most every application tends to do these days.  I
>>> had always figured that there a likely plenty of ppl complaining and I
>>> didn't want to get the boiler plat answer that resources are cheap.
>>>
>>> I refuse to buy into the idea that Z computers can get an additional Y
>>> resource to run application X, when instead application X could be
>>> engineered once and for all.  This ideology is not sustainable and
>>> eventually will crash upon it's self.  I call this Z * Y < X.  The
>>> application source becomes the single location where every computers
>>> resources can be increased at the cost of much less then to adjust the
>>> running environment of every location that the code may run.
>>>
>>> Here is a 84MB video that demonstrates the issue.
>>> http://j.mp/wavbCO
>>> http://bitly.com/wavbCO+
>> I'm glad to see a number of you have clicked on this link.
>>
>> Does this behavior look normal or is it just my system?  If it is normal
>> how difficult would it be to make corrections and would those
>> corrections likely be kernel or application related?
> That "Backup complete" makes me suspect a classic case of IO-itis.  If
> bits of your GUI were pushed out or ram (or weren't previously used),
> and live on a disk you're beating hell out of, you get to experience
> horrid interactivity while those missing bits are being retrieved.
Thank you for the reply!

That's DVDShrink, copies from optical drive(slow) to disk(fast-ish?).
http://www.dvdshrink.info/

That wouldn't explain why the monitor(gkrellm) stopped updating, every
part of that is pooling like top would.  Gkrellm indicates disk activity
and it shows the backup complete on sr1 and a backup in progress on sr0,
however neither of these operations rate on Disk or sda.

I wouldn't suspect that 16MB/s could saturate an HD disk, perhaps I can
buffer this better?

> 	-Mike
>

