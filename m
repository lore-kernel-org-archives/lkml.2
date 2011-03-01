Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487Ab1CANVu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 08:21:50 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35249 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048Ab1CANVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 08:21:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nGfOhO+mlvnxxDbFxBMz7bCoyeuXmjWqNV8SUAYGhe9LUJVwZRqa5wTRmSSDjZXDvj
         zjZFMsYyUFvLj0dHu/sFR8sfXdHhekwB2OIei/wPVB2lHzZnc7cvVGmEWR1JHDo4cmFc
         6FzIPEDn7i9uG+2eRaqX4jlX25JnpIwZUVsRE=
Date: Tue, 1 Mar 2011 21:20:50 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Borislav Petkov <bp@alien8.de>, Sam Ravnborg <sam@ravnborg.org>,
        Michal Marek <mmarek@suse.cz>, torvalds@linux-foundation.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, linux-kbuild@vger.kernel.org,
        bp@amd64.org
Subject: Re: [PATCH -v4] kbuild: Add extra gcc checks
Message-ID: <20110301132050.GA24374@cr0.private>
References: <20110221110322.GA9819@liondog.tnic>
 <201102282207.33489.arnd@arndb.de>
 <20110228213134.GA10825@liondog.tnic>
 <201103011235.00389.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201103011235.00389.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 01, 2011 at 12:35:00PM +0100, Arnd Bergmann wrote:
>On Monday 28 February 2011, Borislav Petkov wrote:
>> My intention was not to have multiple levels of warnings because then
>> you have to go and enable the different levels and have to remember
>> which level you used last, etc, etc.
>
>I wasn't suggesting more than two, so the two would have very distinct
>definitions:
>
>W=1: Warnings that we would like to fix all over the tree, patches to
>     remove these are always welcome and you can build the entire kernel
>     with it. Once they are all fixed, we can make the warnings the default.
>
>W=2: Warnings that we know we don't always want to fix, meant for what
>     you describe here -- you build a single file and decide what to
>     do based on common sense. 
>

Right, this makes sense. Borislav, could you implement this?

Thanks.

