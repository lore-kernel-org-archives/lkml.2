Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528Ab1HSHwd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 03:52:33 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:47316 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215Ab1HSHwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 03:52:30 -0400
MIME-Version: 1.0
In-Reply-To: <1313736686.17978.15.camel@dagon.hellion.org.uk>
References: <1312465977-12388-1-git-send-email-corentin.chary@gmail.com>
	<1313484365-22129-1-git-send-email-corentincj@iksaif.net>
	<1313736686.17978.15.camel@dagon.hellion.org.uk>
Date: Fri, 19 Aug 2011 09:52:29 +0200
Message-ID: <CAHR064hobmPOwvAYX_NKrMqXNZV3PM1VrB6aBn2GrkfmN1F8eA@mail.gmail.com>
Subject: Re: [PATCH v3] scripts: add extract-vmlinux
From: Corentin Chary <corentin.chary@gmail.com>
To: Ian Campbell <ijc@hellion.org.uk>
Cc: linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        Dick Streefland <dick@streefland.net>,
        WANG Cong <xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 19, 2011 at 8:51 AM, Ian Campbell <ijc@hellion.org.uk> wrote:
> On Tue, 2011-08-16 at 10:46 +0200, Corentin Chary wrote:
>> This script can be used to extract vmlinux from a compressed
>> kernel image (bzImage, etc..). It's inspired from (a subset of)
>> extract-ikconfig.
>
> FWIW I wrote the attached way back when, it uses the payload_* fields in
> the bzImage to find the payload rather than scanning (these are present
> in bzImages from somewhere in the mid 2.6.2x range). I'd be happy to
> license it under the GPLv2 if that is helpful.

I think it's good to know that this code exist, but it's better to
keep the current code that's both simple and stupid because I'd really
want to avoid implemeting a specific method for bzImages if the
generic one is solid enought. The current method has the great
advantage of being esasy to port to other formats.

>> It's something a lot of people have been looking for (mainly
>> people with xen < 4 that doesn't support bzImages at all).
>
> xen 3.4 does, doesn't it (at least the tip of 3.4-testing.hg does)? And
> I thought e.g. RHEL5 (which uses an older base version) had it
> backported. Possibly what is missing is support for all the various
> compression options.

Well I don't know about RHEL5, but I know that it doesn't work on
ubuntu 8.04 (and unfortunatly I'm stuck with one of these servers).
But this script can also be used for debuging purpose, or anything
else needing the raw vmlinux.

Thanks for the tips anyway :).

-- 
Corentin Chary
http://xf.iksaif.net
