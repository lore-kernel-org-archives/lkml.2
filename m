Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547Ab1JKMlk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 08:41:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39806 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942Ab1JKMlj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 08:41:39 -0400
Message-ID: <4E943980.8040807@suse.cz>
Date: Tue, 11 Oct 2011 14:41:36 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.20) Gecko/20110804 SUSE/3.1.12 Thunderbird/3.1.12
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Johann Felix Soden <johfel@gmx.de>, Jiri Kosina <jkosina@suse.cz>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix file references in Kconfig files
References: <1317683499.5990.2.camel@LAPJFS> <4E934066.80109@xenotime.net>	 <alpine.LNX.2.00.1110102350170.14768@pobox.suse.cz>	 <1318288249.12675.6.camel@LAPJFS> <1318320079.18122.38.camel@x61.thuisdomein>
In-Reply-To: <1318320079.18122.38.camel@x61.thuisdomein>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11.10.2011 10:01, Paul Bolle wrote:
> On Tue, 2011-10-11 at 01:10 +0200, Johann Felix Soden wrote:
>> This patch fixes file references to moved or deleted files
>> outside of Documentation/.
> 
> Apparently you grepped on something like "<file:.*". This triggers an
> issue I've been wondering about a bit.
> 
> Would anyone know why some file references are wrapped in a "<file:" -
> ">" pair while others are not? The same thing can be seen with "http://"
> links: some are wrapped in angle brackets while others are not. What do
> these brackets (and the "file:" prefix) actually provide?

I guess the plan was to display these references as clickable links in
the graphical front-ends, but this has never been implemented.

Michal
