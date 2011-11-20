Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163Ab1KTQRg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Nov 2011 11:17:36 -0500
Received: from vamos2c.informatik.uni-erlangen.de ([131.188.42.15]:38331 "EHLO
	vamos2c.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752241Ab1KTQRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Nov 2011 11:17:33 -0500
X-Greylist: delayed 1255 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 Nov 2011 11:17:33 EST
From: Reinhard Tartler <Reinhard.Tartler@informatik.uni-erlangen.de>
To: Michal Marek <mmarek@suse.cz>
Cc: Arnaud Lacombe <lacombar@gmail.com>, linux-kbuild@vger.kernel.org,
        Jean Sacren <sakiwit@gmail.com>, linux-kernel@vger.kernel.org,
        vamos-dev@lists.informatik.uni-erlangen.de
Subject: Re: [PATCH] kconfig: Fix checking return value of 'fwrite'
Organization: Uni Erlangen, Informatik 4, Lehrstuhl =?utf-8?Q?f=C3=BCr?=
 Betriebs- und verteilte Systeme
References: <87lisype1v.fsf@faui43f.informatik.uni-erlangen.de>
	<CACqU3MWZuqgpxG7FSvr2LkqTqwF-gQM8hQSnTTpHpcWT2LHGNA@mail.gmail.com>
	<4EC8FF93.7010706@suse.cz>
X-Url: http://www4.informatik.uni-erlangen.de/~tartler
Date: Sun, 20 Nov 2011 16:53:23 +0100
In-Reply-To: <4EC8FF93.7010706@suse.cz> (Michal Marek's message of "Sun, 20
	Nov 2011 14:24:35 +0100")
Message-ID: <87zkfq6b9o.fsf@faui43f.informatik.uni-erlangen.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On So, Nov 20, 2011 at 14:24:35 (CET), Michal Marek wrote:

> On 7.10.2011 05:29, Arnaud Lacombe wrote:
>> Hi,
>> 
>> 2011/10/6 Reinhard Tartler <Reinhard.Tartler@informatik.uni-erlangen.de>:
>>> fwrite indicates '1' written member if a zero-length string is written.
>> you forgot the "Signed-off-by: " part :)
>
> Reinhard, can I assume
>
> Signed-off-by: Reinhard Tartler
> <Reinhard.Tartler@informatik.uni-erlangen.de>
>
> ? The patch is otherwise correct.

I merely forgot to add that part. I fully agree with the (legal)
implications.

Cheers,
Reinhard,

-- 
Reinhard Tartler                     Department of Computer Science IV
Martensstr 1, 91058 Erlangen Germany, University of Erlangen-Nuremberg
            http://www4.informatik.uni-erlangen.de/~tartler
