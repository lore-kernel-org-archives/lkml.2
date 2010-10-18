Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672Ab0JRTPV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 15:15:21 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:59005 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343Ab0JRTPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 15:15:20 -0400
Message-ID: <4CBC9CC7.7050204@kernel.org>
Date: Mon, 18 Oct 2010 12:15:19 -0700
From: "J.H." <warthog9@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.7
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: More issues found on kernel.org
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.3 (shards.monkeyblade.net [198.137.202.13]); Mon, 18 Oct 2010 12:15:20 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not that the current discussion on IMA, and the recent problems found
with XFS were enough, I've started seeing, rather regularly, what I've
reported in bugzilla

https://bugzilla.kernel.org/show_bug.cgi?id=20702

It looks like a double free is happening somewhere, and the issue
*SEEMS* to be limited to the dynamic web boxes (bugzilla, wiki's, etc)
and those are the only boxes I have running drbd and ocfs2.

Once the initial problem hits, the box more or less grinds to a halt and
will eventually kernel panic and reboot.  Explicitly trying to reboot
the box results in a solidly hung box requiring a hard reset.

Anyone have any thoughts, any extra debugging if/when this should happen
again that would be useful?

- John 'Warthog9' Hawley
