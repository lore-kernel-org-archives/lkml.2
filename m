Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751729Ab0JCXzf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 19:55:35 -0400
Received: from lo.gmane.org ([80.91.229.12]:54618 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751173Ab0JCXze (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 19:55:34 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: walt <w41ter@gmail.com>
Subject: Very bad latency on x86 desktop when a process is swapping: Am I
 expecting too much?
Date: Sun, 03 Oct 2010 16:55:17 -0700
Message-ID: <i8b556$v3$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: adsl-69-234-214-85.dsl.irvnca.pacbell.net
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:2.0b7pre) Gecko/20101001 Thunderbird/3.3a1pre
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi lkml,

This is most likely a corner case for the average linux desktop user, but
it's very annoying for me and I'd like to get a feel for what I 'should' be
expecting.

I track the mozilla-firefox-trunk sources from their hg repository every day,
and there is one place in the build where roughly 20-30 large libraries are
linked, all in one giant gcc command.

All those libraries won't fit in my puny 1GB of RAM, so the machine starts to
swap, naturally.

During the 2-3 minutes that all those libraries are being linked, the machine
is truly unusable for any normal lightweight desktop task like reading email.
The swap usage tops out at about 15% of available swap space.

I know the problem would go away if install more RAM, but that's not my real
question.

What should I realistically expect from a desktop workstation under these
fairly uncommon conditions?

Many thanks.

