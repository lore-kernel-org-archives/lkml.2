Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237Ab2KEIUK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 03:20:10 -0500
Received: from 1wt.eu ([62.212.114.60]:35563 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751979Ab2KEIUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 03:20:09 -0500
Date: Mon, 5 Nov 2012 09:19:52 +0100
From: Willy Tarreau <w@1wt.eu>
To: Zhi Yong Wu <zwu.kernel@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>, bernhard.kohl@nsn.com,
        herton.krzesinski@canonical.com
Subject: Re: [ 00/24] 3.6.6-stable review
Message-ID: <20121105081952.GA6601@1wt.eu>
References: <20121102170247.406319110@linuxfoundation.org> <CAEH94LhVHXEEk0XzL3z_EyUDpRMeP02MTUGBxzV5=oOxWGDu3g@mail.gmail.com> <20121105074149.GA1947@kroah.com> <CAEH94Li35RG4RtCDF400xq-PTGTh4E+2AJCA30C5KVVpoDGY7A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEH94Li35RG4RtCDF400xq-PTGTh4E+2AJCA30C5KVVpoDGY7A@mail.gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 05, 2012 at 03:46:31PM +0800, Zhi Yong Wu wrote:
> > And really, the 80 characters is just a "hint", it's not a hard and fast
> > rule for anything here.  Especially for the old, and horrible, floppy
> > and scsi drivers :)
> ok, thanks.

And even worse, look at the staging/panel driver I wrote a long time ago,
someone found it smart to truncate it to 80 chars, resulting in some
expressions being written on 10 lines between the 75 and 80th column...
Now it's unreadable. Definitely not something to do.

Willy

