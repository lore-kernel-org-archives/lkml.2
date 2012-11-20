Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752514Ab2KTQVg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 11:21:36 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:39515 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600Ab2KTQVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 11:21:35 -0500
MIME-Version: 1.0
In-Reply-To: <20121120134051.GA8111@elf.ucw.cz>
References: <CAFnufp3SdnBoFiC5j2bjrA=MW-WfsmFVhfggJvoHa-5ZEgg7aA@mail.gmail.com>
 <20121106044346.GA23799@kroah.com> <20121120134051.GA8111@elf.ucw.cz>
From: Matteo Croce <technoboy85@gmail.com>
Date: Tue, 20 Nov 2012 17:20:52 +0100
Message-ID: <CAFnufp34=ZVsrOTaC++24U-3eQCjyPvQcRrqyrwP8JwM0ykAyg@mail.gmail.com>
Subject: Re: Kernel Source updater script
To: Pavel Machek <pavel@ucw.cz>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have an updated version here:

git://github.com/teknoraver/misc.git

2012/11/20 Pavel Machek <pavel@ucw.cz>:
> On Tue 2012-11-06 05:43:46, Greg KH wrote:
>> On Tue, Nov 06, 2012 at 12:52:46AM +0100, Matteo Croce wrote:
>> > Hi all,
>> >
>> > I know that this is useless to people using git, but it was so fun to write
>> > and I use it to update regularly my pc kernel source from time to time
>> > while saving servers (and home) bandwidth
>>
>> Have you looked at the python script called 'ketchup'?  I think it
>> already does a lot of what you are doing here.
>
> I tried to get it to work with 3.x kernels, and I don't think I was
> successful. Hopefully someone else did the job?
>
> It would be nice to include it in the scripts/ directory, to save
> duplicate work. (Or drivers/staging/scripts? :-).
>                                                                         Pavel
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html



-- 
Matteo Croce
OpenWrt Developer
 _______                     ________        __
|       |.-----.-----.-----.|  |  |  |.----.|  |_
|   -   ||  _  |  -__|     ||  |  |  ||   _||   _|
|_______||   __|_____|__|__||________||__|  |____|
         |__| W I R E L E S S   F R E E D O M
ATTITUDE ADJUSTMENT (bleeding edge) --------------
 * 1/4 oz Vodka      Pour all ingredients into mixing
 * 1/4 oz Gin        tin with ice, strain into glass.
 * 1/4 oz Amaretto
 * 1/4 oz Triple sec
 * 1/4 oz Peach schnapps
 * 1/4 oz Sour mix
 * 1 splash Cranberry juice
-----------------------------------------------------
