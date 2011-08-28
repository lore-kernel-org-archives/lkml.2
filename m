Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938Ab1H1SUe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Aug 2011 14:20:34 -0400
Received: from void.printf.net ([89.145.121.20]:43722 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751779Ab1H1SU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Aug 2011 14:20:29 -0400
From: Chris Ball <cjb@laptop.org>
To: ian@mnementh.co.uk
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org
Subject: Re: [PATCH] mmc: tmio: eliminate unused variable 'mmc' warning
References: <1312354138.14329.1.camel@phoenix>
	<Pine.LNX.4.64.1108030924440.28502@axis700.grange>
	<m2liva7ize.fsf@bob.laptop.org> <1314471775.2138.28.camel@drake>
Date: Sun, 28 Aug 2011 14:20:20 -0400
In-Reply-To: <1314471775.2138.28.camel@drake> (Ian Molton's message of "Sat,
	27 Aug 2011 20:02:51 +0100")
Message-ID: <m2k49xxusb.fsf@bob.laptop.org>
User-Agent: Gnus/5.110018 (No Gnus v0.18) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ian,

On Sat, Aug 27 2011, Ian Molton wrote:
> On Wed, 2011-08-03 at 08:55 -0400, Chris Ball wrote:
>> > Good for 3.1, do we also push such "harmless" compiler warning fixes
>> > to stable?
>> >
>> > Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
>> 
>> Pushed for 3.1, thanks.  I don't think this is appropriate for stable.
>
> Why on earth not? its obviously correct...

Because the rules for stable@ consist of more than the patch being
obviously correct.

You seem to have chosen one stable@ rule that this patch meets, and
ignored the other nine which it mostly does not meet:

Documentation/stable_kernel_rules.txt:
 - It must fix a real bug that bothers people (not a, "This could be a
   problem..." type thing).
 - It must fix a problem that causes a build error (but not for
   things marked CONFIG_BROKEN), an oops, a hang, data corruption,
   a real security issue, or some "oh, that's not good" issue.
   In short, something critical.
 - It cannot contain any "trivial" fixes in it (spelling changes,
   whitespace cleanups, etc).

Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
