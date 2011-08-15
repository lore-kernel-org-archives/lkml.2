Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825Ab1HOUXe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 16:23:34 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:53268 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751957Ab1HOUXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 16:23:33 -0400
Date: Mon, 15 Aug 2011 13:23:31 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mike Waychison <mikew@google.com>, Greg KH <gregkh@suse.de>,
        lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Theodore Tso <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Documentation: add Internal-reference-ID: patch tag
Message-Id: <20110815132331.74cd0484.rdunlap@xenotime.net>
In-Reply-To: <4E496529.5080702@zytor.com>
References: <20110729180028.6a2091b3.rdunlap@xenotime.net>
	<20110730235644.GA29671@suse.de>
	<CAGTjWtDXeMnHWZMmRezTSYmHr3D1N1KRXzzdjQh9HJMxvj8pwg@mail.gmail.com>
	<4E359A74.7090408@zytor.com>
	<20110813123401.76ffcfcc.rdunlap@xenotime.net>
	<2d50505d-3500-47d8-84d4-b32850bdec7e@email.android.com>
	<20110814202322.16b50ff5.rdunlap@xenotime.net>
	<4E48AC7D.4030908@zytor.com>
	<CAGTjWtD2Xz6gE6mDM6zOqDic=JZ5A9UtRzTLnUTAputc=KEZ+Q@mail.gmail.com>
	<4E496529.5080702@zytor.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Aug 2011 11:27:53 -0700 H. Peter Anvin wrote:

> On 08/15/2011 10:39 AM, Mike Waychison wrote:
> >>
> >> I would like to see the <id@owner> format I mentioned.
> > 
> > Is there a middle ground if we say:
> > 
> > Internal-reference-ID: <arbitrarytextforid@owner>
> > 
> > so
> > 
> > Internal-reference-ID: <2011.0729.id1@rdunlap>
> > Internal-reference-ID: <bug-45322143@google>
> > 
> 
> Personally I don't care if they are separate lines or all on the same line.

I don't understand how that answers Mike's question...

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
