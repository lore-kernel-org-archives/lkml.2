Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932452Ab2LFJf0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 04:35:26 -0500
Received: from multi.imgtec.com ([194.200.65.239]:52749 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932377Ab2LFJfZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 04:35:25 -0500
Message-ID: <50C066D9.9010700@imgtec.com>
Date: Thu, 6 Dec 2012 09:35:21 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Arnd Bergmann" <arnd@arndb.de>
Subject: Re: [PATCH v2 12/44] metag: TBX source
References: <1354723742-6195-1-git-send-email-james.hogan@imgtec.com>  <1354723742-6195-13-git-send-email-james.hogan@imgtec.com> <1354733607.8320.3.camel@joe-AO722>
In-Reply-To: <1354733607.8320.3.camel@joe-AO722>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2012_12_06_09_35_22
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/12 18:53, Joe Perches wrote:
> On Wed, 2012-12-05 at 16:08 +0000, James Hogan wrote:
>> Add source files from the Thread Binary Interface (TBI) library which
>> provides useful low level operations and traps/context management.
> []
>>  arch/metag/tbx/tbicache.c  |  462 ++++++++++++++++++++++++++++++++++++++++++++
> 
> Could you please run checkpatch on this file?

Hi Joe,

Thanks for taking a look.

I'd prefer to avoid making style modifications to the tbx/ files if
possible to ease maintenance, as the code is shared with other projects
and maintained by a separate group.

Of course if cleaning up the style is deemed absolutely necessary then
so be it.

Cheers
James

