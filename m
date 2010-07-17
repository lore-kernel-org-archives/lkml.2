Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913Ab0GQXSz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jul 2010 19:18:55 -0400
Received: from khc.piap.pl ([195.187.100.11]:46910 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755671Ab0GQXSw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jul 2010 19:18:52 -0400
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Dimitrios Apostolou <jimis@gmx.net>, linux-kernel@vger.kernel.org,
        Dan Nicolaescu <dann@gnu.org>
Subject: Re: emacs and "linux" coding style
References: <alpine.LNX.2.00.1007131644180.1500@localhost.localdomain>
	<m3tyny31mo.fsf@intrepid.localdomain>
	<20100717065146.732f5449.rdunlap@xenotime.net>
Date: Sun, 18 Jul 2010 01:18:49 +0200
In-Reply-To: <20100717065146.732f5449.rdunlap@xenotime.net> (Randy Dunlap's
	message of "Sat, 17 Jul 2010 06:51:46 -0700")
Message-ID: <m3k4otvgrq.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap <rdunlap@xenotime.net> writes:

> fwiw, it seems that you agree with Ted.

That's correct :-)

>> The tabs should be used for (syntactic) indentation only.
>> This way we can display the code correctly with any tab length.
>
> but we know what the tab length is.  ;)

We have to, at least for now. Existing tools force it upon us.
But it would be nice if we could use any tab length.
-- 
Krzysztof Halasa
