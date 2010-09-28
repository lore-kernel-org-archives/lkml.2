Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260Ab0I1WfI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 18:35:08 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:59608 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668Ab0I1WfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 18:35:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:in-reply-to:references:user-agent:date
         :message-id:mime-version:content-type;
        b=p480vLsVy3R1uKz93GgZxw8kKKv6/xo485KckQ5bTXYSsmUhtel+JVhacqxWw1U560
         1pHRaERZuh3ohiN7d6/BVAIYvCoTw7NfkpgQGEFmjuYwef/WNr6B30vsuEEWhWZb3h4f
         2D8jF+lkmejPUnPyK9DdCTugegjCaqNHkHkm0=
From: Ben Gamari <bgamari@gmail.com>
To: Raymond Liu <raymondliu3linux@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: HDMI open source to handle audio/video/CEC in one driver
In-Reply-To: <AANLkTikxzY9KP2zzQ+pXN0t_5Z4L7kHyd_Xz5fD+GcZn@mail.gmail.com>
References: <AANLkTimMH604FW_NZehY68w8B_cV_Lhe-ZwZq0cAYUfd@mail.gmail.com> <AANLkTi=mLizQGyp5cdR_WtHjMMhixBOOagkFUNVqO4vj@mail.gmail.com> <Pine.LNX.4.64.1009281624100.11083@axis700.grange> <AANLkTikxzY9KP2zzQ+pXN0t_5Z4L7kHyd_Xz5fD+GcZn@mail.gmail.com>
User-Agent: Notmuch/0.3.1-62-g4723706 (http://notmuchmail.org) Emacs/23.1.1 (x86_64-pc-linux-gnu)
Date: Tue, 28 Sep 2010 18:35:01 -0400
Message-ID: <8739stxzsa.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Sep 2010 13:07:40 -0700, Raymond Liu <raymondliu3linux@gmail.com> wrote:
> Hi Ben and Guennadi,
> 
> Really appreciate your inputs.
> 
> For temporarily short term purpose (we already had a driver but it did
> not fit into any of these you mentioned), what is the process we
> should follow to make it an "open source"?
> 
Well, "release early, release often" is a good mantra to follow. Even if
you think the code is not ready, it never does any harm to put it up
somewhere for folks to look at under an open source license (GPL would
be a good idea if you are looking to merge upstream).

If you are serious about bringing a usable driver to the masses you
should clean up the code and adapt it to fit into one of the existing
frameworks for exposing graphics devices, along with bringing the driver
into conformance with the Linux kernel style guidelines. Once the driver
is beginning to look ready to merging upstream you can request that it
be pulled into the -staging tree. When you think the driver is ready for
inclusion in the kernel you can request merging upstream and start the
code review process.

- Ben
