Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229Ab1HMTeK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 15:34:10 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:44143 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751847Ab1HMTeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 15:34:04 -0400
Date: Sat, 13 Aug 2011 12:34:01 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mike Waychison <mikew@google.com>, Greg KH <gregkh@suse.de>,
        lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Theodore Tso <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Documentation: add Internal-reference-ID: patch tag
Message-Id: <20110813123401.76ffcfcc.rdunlap@xenotime.net>
In-Reply-To: <4E359A74.7090408@zytor.com>
References: <20110729180028.6a2091b3.rdunlap@xenotime.net>
	<20110730235644.GA29671@suse.de>
	<CAGTjWtDXeMnHWZMmRezTSYmHr3D1N1KRXzzdjQh9HJMxvj8pwg@mail.gmail.com>
	<4E359A74.7090408@zytor.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 31 Jul 2011 11:09:56 -0700 H. Peter Anvin wrote:

> On 07/31/2011 11:07 AM, Mike Waychison wrote:
> >>>
> >>> Internal-reference-ID: rdunlap.2011.0729.id1
> >>>
> > 
> > Acked-by: Mike Waychison <mikew@google.com>
> > 
> 
> Just to avoid namespace collisions, can we at least put the owner
> somewhere standardized, e.g. <2011.0729.id1@rdunlap>, <33999@google> and
> so on?

I would prefer to leave the text contents as unspecified, but I wouldn't
mind recommending that users try to make them unique, e.g., by using
a company-ID or owner-ID.  Would that be acceptable?


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
