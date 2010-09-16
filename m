Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345Ab0IPObz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 10:31:55 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:51425 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754866Ab0IPOby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 10:31:54 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX19s4jMzF7hszn6gDmVorUncfmJaBMy4UJB27aLa8I
	MrMO2++jZ8vH0w
Message-ID: <4C922A55.3050002@gmx.de>
Date: Thu, 16 Sep 2010 16:31:49 +0200
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100328)
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>
CC: torvalds@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] viafb security fix
References: <4C9162BA.6000307@gmx.de> <20100916080456.0f50ec6a@bike.lwn.net>
In-Reply-To: <20100916080456.0f50ec6a@bike.lwn.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Corbet schrieb:
> On Thu, 16 Sep 2010 02:20:10 +0200
> Florian Tobias Schandinat <FlorianSchandinat@gmx.de> wrote:
> 
>> It contains a single patch to initialize the memory before it is copied to 
>> userspace. As this issue could be a security flaw it would be good to have this 
>> patch in the next release.
> 
> This one seems worth directing toward the stable tree as well.

True, the author did CC stable@kernel.org so I guess it should be okay.
Sorry for not making that clear in the patch itself.


Thanks,

Florian Tobias Schandinat

