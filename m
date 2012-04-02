Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751807Ab2DBKhc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 06:37:32 -0400
Received: from clearmind.me ([109.169.77.6]:51375 "EHLO clearmind.me"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751145Ab2DBKhb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 06:37:31 -0400
X-Greylist: delayed 1308 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Apr 2012 06:37:31 EDT
Subject: Re: [s2disk] Inappropriate ioctl on /dev/snapshot
From: venom00 <venom00@setsun.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        kernel list <linux-kernel@vger.kernel.org>,
        pavel@users.sourceforge.net, rjwysocki@users.sourceforge.net
In-Reply-To: <20120402100625.GA1216@elf.ucw.cz>
References: <EV0ByeH8JeDWvk23_hS3M1XIjq7ZqojHm-IJJdI6CcZXMuZdq2gOAlqCGWMX1UCTpf9qG5vgeUMtaBztXYzLkQ@localhost.localdomain>
	 <20120402100625.GA1216@elf.ucw.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 02 Apr 2012 12:15:34 +0200
Message-ID: <9Jr6_fKFH8Umxxs-dQGSOyRp3KqouVJ5VXrBfs1lJmHEgv6ITSoG7dqJWPT6sPGR8h5aOXDJHpJMUxXb0X1vvw@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-02 at 12:06 +0200, Pavel Machek wrote:
> 
> Hi! If it worked on previous kernels, it is an  regression and
> something for rjw to track.

It's my first try with Xen.

> By chance, are you using 32bit userland on 64bit kernel?

No.

> (Rafael: Did we remove some compatibility code, recently?) 

Sorry, I've updated suspend-1.0 and works fine ;)

Thanks for answering!

