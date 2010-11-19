Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053Ab0KSTMW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 14:12:22 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:58722 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754861Ab0KSTMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 14:12:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:in-reply-to:references:user-agent:date
         :message-id:mime-version:content-type;
        b=FfrxQ1Etx3rUp0L4bA6owl6FrM1+WinuEia8y3/+UokWCIEAJibbQvV3hV0siN1LjZ
         dUMO9wXmsJU3aPv5pj3YD/FRxQKycgtaoyKOlXDsbqsL9Poo7VSNJJFHFlUYKoIkntzO
         86+QEGK+xFjPJ+Pm3xExo37Thck0uh6UUQkBY=
From: Ben Gamari <bgamari.foss@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        David Miller <davem@davemloft.net>
Cc: mzxreary@0pointer.de, tytso@mit.edu, a.p.zijlstra@chello.nl,
        debiandev@gmail.com, alan@lxorguk.ukuu.org.uk, dhaval.giani@gmail.com,
        efault@gmx.de, vgoyal@redhat.com, oleg@redhat.com,
        markus@trippelsdorf.de, mathieu.desnoyers@efficios.com, mingo@elte.hu,
        linux-kernel@vger.kernel.org, balbir@linux.vnet.ibm.com
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
In-Reply-To: <AANLkTiksmvcLKGx7-u5CnTnZU6dgOgg7wem6qf384zUg@mail.gmail.com>
References: <C47257FC-498A-41B0-BC94-C81C72601D53@mit.edu> <20101119.082944.226775934.davem@davemloft.net> <20101119163430.GA12353@tango.0pointer.de> <20101119.084302.71115175.davem@davemloft.net> <AANLkTiksmvcLKGx7-u5CnTnZU6dgOgg7wem6qf384zUg@mail.gmail.com>
User-Agent: Notmuch/0.5-3-g22aadfc (http://notmuchmail.org) Emacs/23.1.1 (x86_64-pc-linux-gnu)
Date: Fri, 19 Nov 2010 14:12:17 -0500
Message-ID: <87mxp53z72.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Nov 2010 09:51:14 -0800, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> And the user level approach? I think it's fine too. If you run systemd
> for other reasons (or if the gnome people add it to the task launcher
> or whatever), doing it there isn't wrong. I personally think it's
> somewhat disgusting to have a user-level callback with processes etc
> just to clean up a group, but whatever.  As long as it's not common,
> who cares?
> 
On that note, is there a good reason why the notify_on_release interface
works the way it does? Wouldn't it be simpler if the cgroup simply
provided a file on which a process (e.g. systemd) could block?

I guess it's a little too late at this point considering the old
mechanism will still need to be supported, but it seems like this would
provide a slightly cheaper cleanup path. Just my (perhaps flawed) two
pence.

> 
> So guys, calm down. We don't need to hate each other.
>
Thanks for the nudge back to sanity.

Cheers,

- Ben
