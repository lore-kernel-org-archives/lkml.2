Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906Ab1HBAT1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 20:19:27 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:57337 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752361Ab1HBATV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 20:19:21 -0400
Date: Mon, 1 Aug 2011 17:19:19 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Sergiu Iordache <sergiu@google.com>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        marco.stornelli@gmail.com
Subject: Re: [PATCH] char drivers: ramoops documentation
Message-Id: <20110801171919.307cd945.rdunlap@xenotime.net>
In-Reply-To: <CAGDaqBSrbH4JV0xS8YHedy1H6O86rk0HLxjtd15C0-GchsNOvg@mail.gmail.com>
References: <1312234010-18004-1-git-send-email-sergiu@chromium.org>
	<20110801150542.7b15e55d.rdunlap@xenotime.net>
	<CAGDaqBSrbH4JV0xS8YHedy1H6O86rk0HLxjtd15C0-GchsNOvg@mail.gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Aug 2011 15:37:49 -0700 Sergiu Iordache wrote:

> On Mon, Aug 1, 2011 at 3:05 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> > On Mon,  1 Aug 2011 14:26:50 -0700 Sergiu Iordache wrote:
> >
> >> Add a documentation file describing the usage of Ramoops
> >>
> >> Change-Id: I9dab9c4b9e4921b220574470372e330d32f9c63b
> >
> > eh?
> Sorry, was it the commit message you did not like or something else?

The "Change-Id:" line.
There was a discussion that began with a July 14 patch from Mike Waychison
<mikew@google.com>:
Subject: [PATCH 1/2] Kconfig:  Allow disabling of CONFIG_DEVPORT

that included the line:
Google-Bug-Id: 3177114

Basically we don't want umpteen zillion different such tags in commit
messages.  I posted a patch last Friday:
Subject: [PATCH] Documentation: add Internal-reference-ID: patch tag

that allows people who want to track their internal references in commit
messages to use a common tag label/format:

Internal-reference-ID: <text>

<text> should not be a private (internal) URL.


> Thanks, I've updated the doc using your feedback. I have also
> rearranged the "1. Ramoops concepts" part to make it look better I
> think. I'll wait a bit for some more comments and then resubmit the
> new version of the patch.

Thanks.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
