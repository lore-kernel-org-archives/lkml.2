Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371Ab0KSQ3V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 11:29:21 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44858
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754857Ab0KSQ3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 11:29:19 -0500
Date: Fri, 19 Nov 2010 08:29:44 -0800 (PST)
Message-Id: <20101119.082944.226775934.davem@davemloft.net>
To: tytso@MIT.EDU
Cc: bgamari.foss@gmail.com, a.p.zijlstra@chello.nl, debiandev@gmail.com,
        mzxreary@0pointer.de, torvalds@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, dhaval.giani@gmail.com, efault@gmx.de,
        vgoyal@redhat.com, oleg@redhat.com, markus@trippelsdorf.de,
        mathieu.desnoyers@efficios.com, mingo@elte.hu,
        linux-kernel@vger.kernel.org, balbir@linux.vnet.ibm.com
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
From: David Miller <davem@davemloft.net>
In-Reply-To: <C47257FC-498A-41B0-BC94-C81C72601D53@mit.edu>
References: <1290167993.2109.1562.camel@laptop>
	<8762vtsbx5.fsf@gmail.com>
	<C47257FC-498A-41B0-BC94-C81C72601D53@mit.edu>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Theodore Tso <tytso@MIT.EDU>
Date: Fri, 19 Nov 2010 08:07:12 -0500

> 
> On Nov 19, 2010, at 8:03 AM, Ben Gamari wrote:
> 
>>> t means it will become
>>> impossible to sanely switch off (gnome firmly believes knobs are evil),
>>> leaving everybody who _does_ know wth they're doing up a certain creek
>>> without a paddle.
>> 
>> Please, can we stop with this false dichotomy? This is decidedly not
>> true and as Lennart has already pointed out, the knob already exists in
>> systemd. You may like the kernel approach, but this does not mean there
>> is no place for grouping driven by userspace.
> 
> Yes, and then at the next release, some idiotic GNOME engineer will
> decide to the "improve" the system by removing yet another knob....

I have to agree on this one, there is no reason to believe that this
trend will not continue and I've lost every ounce of optimism I've
ever had in this area.

Besides, I'm having trouble believing someone who can't even get it
through his thick skull that even "M-x compile" in emacs gives a TTY
to the make process.  Yet he kept claiming the opposite over and over
again until I absolutely proved it to him, at which point he became
completely silent on that line of reasoning.

Someone who argues and behaves in that way is not someone I put much
stock in as far as implementing things in a wise or well informed way,
it feels more like a mechanism which is being forced and rushed ahead
without enough research or consideration.
