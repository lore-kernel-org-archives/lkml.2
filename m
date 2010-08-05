Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934507Ab0HEWGg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 18:06:36 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:49848 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933704Ab0HEWGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 18:06:30 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4C5B35DB.7010302@s5r6.in-berlin.de>
Date: Fri, 06 Aug 2010 00:06:19 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100627 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Bjarke Istrup Pedersen <gurligebis@gentoo.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: Best way to send several patches
References: <AANLkTin5gz-NBGYrmdOQ4F4s-fbETq642JVsHEEJY4HD@mail.gmail.com>
In-Reply-To: <AANLkTin5gz-NBGYrmdOQ4F4s-fbETq642JVsHEEJY4HD@mail.gmail.com>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjarke Istrup Pedersen wrote:
> I'm reading on the kernelnewbies wiki about janitor work needing be to done.
> I have been cleaning up some stuff, and have alot of patches (I have
> split my changed into smaller patches).

Good.

> The question is, should I just send them all to this mailinglist
> (Section 3 of Documentation/SubmittingPatches - the one with the patch
> bomb - suggest that this is a bad idea), or how should I do it? (I
> have only submitted a single patch before, so I didn't have to worry
> about that back then).
> 
> I have been thinking about sending a pull request, but since I've only
> done one patch up until now, I find it unlikely to be trusted enough
> to get a pull request through (correct me if I'm wrong).

Send the patches to the respective subsystem mailinglist.  Cc the
responsible maintainer and lkml.

However, the current time is not ideal:  A merge window is open, with
code in the mainline changing quickly and maintainers being busy with
integration;  not helped by the fact that some Linux conferences are
imminent.  Consider to wait until 2.6.36-rc1 was released, then check
whether your patches are still applicable on top of 2.6.36-rc1, then
post them.
-- 
Stefan Richter
-=====-==-=- =--- --=-=
http://arcgraph.de/sr/
