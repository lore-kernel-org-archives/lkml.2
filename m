Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964979Ab2CNAwQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 20:52:16 -0400
Received: from usmamail.tilera.com ([206.83.70.75]:13023 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759375Ab2CNAwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 20:52:13 -0400
Message-ID: <4F5FEBBB.9030207@tilera.com>
Date: Tue, 13 Mar 2012 20:52:11 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] arch/tile update for 3.3
References: <4F5FCF6E.6060403@comcast.net> <CA+55aFySHdJ_LM4N7UhWektRoGK9f4+18=8xr3bMgK4gHuMqEg@mail.gmail.com>
In-Reply-To: <CA+55aFySHdJ_LM4N7UhWektRoGK9f4+18=8xr3bMgK4gHuMqEg@mail.gmail.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/13/2012 8:06 PM, Linus Torvalds wrote:
> On Tue, Mar 13, 2012 at 3:51 PM, Chris Metcalf <cdmetcalf@comcast.net> wrote:
>> These include a couple of queued-up minor bug fixes from the community, a fix
>> to unbreak the sysfs hooks in tile, and syncing up the defconfigs.
> Ugh. When doing defconfigs, please try to use the new minconfig
> machinery to generate a somewhat sane config file, instead of one that
> contains everything.
>
> They get smaller, and actually way more relevant too.

OK, I'll look at that for 3.4.  Thanks!

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

