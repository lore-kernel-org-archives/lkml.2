Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331Ab2KLJKc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 04:10:32 -0500
Received: from claranet-outbound-smtp05.uk.clara.net ([195.8.89.38]:35851 "EHLO
	claranet-outbound-smtp05.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751502Ab2KLJK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 04:10:29 -0500
From: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        John McCutchan <john@johnmccutchan.com>, Robert Love <rlove@rlove.org>,
        Eric Paris <eparis@parisplace.org>, Eric Paris <eparis@redhat.com>,
        Nepomuk Mailing List <nepomuk@kde.org>,
        Linux Filesystem Development Mailinglist 
	<linux-fsdevel@vger.kernel.org>
Subject: Re: Better support for (desktop) file search / indexing applications
Date: Mon, 12 Nov 2012 09:10:15 +0000
Message-ID: <10569573.iu1a6eiZCO@deuteros>
User-Agent: KMail/4.8.4 (Linux/3.4.6-2.fc17.x86_64; KDE/4.8.4; x86_64; ; )
In-Reply-To: <201211101753.46211.Martin@lichtvoll.de>
References: <201211011352.42476.Martin@lichtvoll.de> <6898338.Kmf2pUBmi1@deuteros> <201211101753.46211.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 10 November 2012 17:53:45 Martin Steigerwald wrote:
> Still fanotify needs root access and thus this would need a daemon running
> as root and some policy kit stuff to access it and in case of mount point
> watches robust and secure code so that each user may only see his/her own
> results.

Perhaps then also extend fanotify to support user watches, from the top of my 
head I can't think of a reason it would be very difficult to implement. But it 
has been a few years since I actively worked with that code.

Since you are not the only group having issues with fanotify feature set I can 
see this mini-project (together with extensions from me previous reply) being 
useful. It is also better to evolve it than neglect due a few shortcomings and 
then in a few years someone will come up with something completely new and 
then we will have yet another notification system.

Tvrtko

