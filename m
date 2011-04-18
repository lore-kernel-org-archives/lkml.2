Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755631Ab1DRQIL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 12:08:11 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:50008 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755490Ab1DRQII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 12:08:08 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: "J. Bruce Fields" <bfields@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Neil Brown <neilb@suse.de>, linux-nfs@vger.kernel.org
Subject: Re: [105/105] nfsd4: fix oops on lock failure
References: <20110412143559.186613198@clark.kroah.org>
	<87pqokx6lr.fsf@devron.myhome.or.jp>
	<BANLkTimN6L80e_oiJ_uqbLde2Cdnw5p45Q@mail.gmail.com>
	<20110418153236.GC20935@pad.home.fieldses.org>
Date: Tue, 19 Apr 2011 01:08:00 +0900
In-Reply-To: <20110418153236.GC20935@pad.home.fieldses.org> (J. Bruce Fields's
	message of "Mon, 18 Apr 2011 11:32:38 -0400")
Message-ID: <87ipubwnj3.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"J. Bruce Fields" <bfields@redhat.com> writes:

> On Sun, Apr 17, 2011 at 09:10:12AM -0700, Linus Torvalds wrote:
>> On Sun, Apr 17, 2011 at 8:03 AM, OGAWA Hirofumi
>> <hirofumi@mail.parknet.co.jp> wrote:
>> >
>> > I'm looking filp leak on recent kernel. Well, anyway,
>
> Does this fix it?

It seems to be no, unfortunately. filp leak is not so fast, and obvious
reproduce process is not known yet. Well, sigh, I'm starting to add
debugging code for it...
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
