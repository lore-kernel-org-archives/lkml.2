Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257Ab0GGAHr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 20:07:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50664 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661Ab0GGAHq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 20:07:46 -0400
Message-ID: <4C33C54B.2070804@zytor.com>
Date: Tue, 06 Jul 2010 17:07:39 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
       dmitry.torokhov@gmail.com
Subject: Re: [GIT] kbuild setlocalversion fix
References: <20100702121021.GA10458@sepie.suse.cz>
In-Reply-To: <20100702121021.GA10458@sepie.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2010 05:10 AM, Michal Marek wrote:
> Hi Linus,
> 
> There is a fix to the Makefile not to run scripts/setlocalversion and
> various git commands on every invocation. This was also the case
> previously with CONFIG_LOCALVERSION_AUTO=y, but after 85a256d (kbuild:
> improve version string logic) it happens during every build. Dmitry
> Torokhov complained that make install in a sshfs-mounted tree takes
> extremely long, it also goes against the idea that root should only run
> the necessary minimum of commands. The first patch has been in
> linux-next for a couple of days and I got no complaints, the second one
> is just a minor fix over it and should be safe.
> 

Building 2.6.35-rc4 with O= I get a bunch of:

/bin/sh: scripts/setlocalversion: No such file or directory

	-hpa
