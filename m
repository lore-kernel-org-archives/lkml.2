Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375Ab0JXGoj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 02:44:39 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38204 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754483Ab0JXGoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 02:44:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=FZaqCwFYd02po5/Gxlwz/ug7TamNASj2kqlLuj4ZMPDZKnzF+bh9+AItjNKfkuJkVE
         4auW4d4jgkghSiWCWv3wCKBhH7rIqY+UwDK0LEKwa4ZHgHaSFYYxyH20MeFWSr7uSV8p
         CHM7HpzZUOUYddj8Fgz89GjbOhX9aL7ZW6oQs=
Subject: Re: [BUG] disk_free_ptbl_rcu_cb() crash
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <4CC3CC6F.8090606@fusionio.com>
References: <1287868201.2658.563.camel@edumazet-laptop>
	 <4CC3CC6F.8090606@fusionio.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 24 Oct 2010 08:44:30 +0200
Message-ID: <1287902670.2658.580.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le dimanche 24 octobre 2010 à 08:04 +0200, Jens Axboe a écrit :
> On 2010-10-23 23:10, Eric Dumazet wrote:
> > Current Linus tree makes my machine crash in disk_free_ptbl_rcu_cb(),
> > while booting...
> > 
> > commit 7681bfeeccff5ef seems the problem ?
> > 
> > Following patch solves the NULL dereference, but this is only to show
> > you where the problem is, not a real fix, of course.
> 
> Darn. Your fix is on the right path, you missed one though. I think it's
> cleaner to move this into the elevator helpers, so that the callers can
> remain clean.
> 
> Can you verify that this works too?

Sure, I did right now and it works too, thanks !


