Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933250Ab0LUA6r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 19:58:47 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:46992 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932864Ab0LUA6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 19:58:46 -0500
Message-ID: <4D0FFC4B.9050301@kernel.org>
Date: Mon, 20 Dec 2010 17:00:59 -0800
From: "J.H." <warthog9@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.10
MIME-Version: 1.0
To: David Brown <davidb@codeaurora.org>
CC: sedat.dilek@gmail.com, LKML <linux-kernel@vger.kernel.org>,
        linux-next@vger.kernel.org, ftpadmin@kernel.org, webmaster@kernel.org
Subject: Re: patchwork.kernel.org down
References: <AANLkTik4ktaeyDG3ihh-YRB+WVLxA46wSLOgWy6iY_68@mail.gmail.com> <20101220204936.GA21290@huya.qualcomm.com>
In-Reply-To: <20101220204936.GA21290@huya.qualcomm.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.3 (shards.monkeyblade.net [198.137.202.13]); Mon, 20 Dec 2010 16:58:38 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2010 12:49 PM, David Brown wrote:
> On Mon, Dec 20, 2010 at 09:12:58PM +0100, Sedat Dilek wrote:
> 
>> just FYI: http://patchwork.kernel.org/ is down!

More excitement from https://bugzilla.kernel.org/show_bug.cgi?id=20702

Anyone want to take a stab at it?  I know I'd be appreciative.  I am
running a debug kernel with everything I could find and enable I even
remotely thought might prove helpful.  Nothing has jumped out yet though.

> git.kernel.org seems to be down as well.

git isn't down, but it has been unbelievably busy.  Loads are *only* in
the 60's right now (they have been spiking above 300)

I did mention the loads and the spikes yesterday:

https://lkml.org/lkml/2010/12/20/317

and you can see the loads on the odins (the ones that deal with git) here:

http://cacti.kernel.org/graph_view.php?action=tree&tree_id=3

We are down from the 2700 or so simultaneous git processes to only about
1600 right now (which again the normal range is 100-200).  The onslaught
is subsiding, as it does with any big release, just no one knew it was
going to be nearly as big as it has turned out to be.

- John 'Warthog9' Hawley
