Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755049Ab1EBUf6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 16:35:58 -0400
Received: from cantor.suse.de ([195.135.220.2]:46348 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753164Ab1EBUf5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 16:35:57 -0400
Message-ID: <4DBF15AE.6020201@suse.cz>
Date: Mon, 02 May 2011 22:35:58 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: boris@alien8.de, Sam Ravnborg <sam@ravnborg.org>,
        =?ISO-8859-1?Q?Am=E9?= =?ISO-8859-1?Q?rico_Wang?= 
	<xiyou.wangcong@gmail.com>,
        valdis.kletnieks@vt.edu, bp@alien8.de, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, davej@redhat.com
Subject: Re: [PATCH] kbuild: Allow to combine multiple W= levels
References: <71633.1304013549@localhost>	<1304083893-18849-1-git-send-email-mmarek@suse.cz>	<BANLkTikMf4x0e3UhabUH+c_xnWJMQ3rkvg@mail.gmail.com>	<20110502170736.GB18740@merkur.ravnborg.org>	<BANLkTi==Tx6sXcA2Bk6Cp7wc1DY-7c1V3g@mail.gmail.com>	<2b5d75ba05bd7889ac80514015e36ad2.squirrel@www.skyhub.de> <BANLkTikQ6b8BMYXZcFzmavx-geqzqVvrvA@mail.gmail.com>
In-Reply-To: <BANLkTikQ6b8BMYXZcFzmavx-geqzqVvrvA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2.5.2011 20:45, Arnaud Lacombe wrote:
> Hi,
> 
> On Mon, May 2, 2011 at 2:03 PM,  <boris@alien8.de> wrote:
>> This is exactly why we're trying to get a feeling of this by _running_
>> it and _then_ _bitching_ about it.
>>
> This is just what I did, might you consider it bullshit or not. I
> really do _dislike_ Michal's interface. I proposed a solution, Americo
> did too. I guess that unless a patch is submitted, this will go
> nowhere.

Yes, feel free to submit a patch that does things better. Nothing is set
in stone yet, the code isn't even merged into Linus' tree, let alone
part of some official release.

Michal
