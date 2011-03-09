Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756520Ab1CIB1j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 20:27:39 -0500
Received: from adelie.canonical.com ([91.189.90.139]:41803 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756559Ab1CIB1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 20:27:38 -0500
Message-ID: <4D76D785.8060408@canonical.com>
Date: Tue, 08 Mar 2011 17:27:33 -0800
From: John Johansen <john.johansen@canonical.com>
Organization: Canonical
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: James Morris <jmorris@namei.org>
CC: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [AppArmor 0/3] Cleanups to AppArmor's build
References: <1299610989-3917-1-git-send-email-john.johansen@canonical.com> <alpine.LRH.2.00.1103091025130.28443@tundra.namei.org>
In-Reply-To: <alpine.LRH.2.00.1103091025130.28443@tundra.namei.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2011 03:32 PM, James Morris wrote:
> On Tue, 8 Mar 2011, John Johansen wrote:
> 
>> The following three patches have all been out to the lkml/lsm and have sat in
>> the AppArmor tree for a while.
>>
>> The following changes since commit eae61f3c829439f8f9121b5cd48a14be04df451f:
>>
>>   TOMOYO: Fix memory leak upon file open. (2011-03-03 10:13:26 +1100)
>>
>> are available in the git repository at:
>>   git://git.kernel.org/pub/scm/linux/kernel/git/jj/apparmor-dev.git security-next
>>
>> John Johansen (3):
>>       AppArmor: Cleanup make file to remove cruft and make it easier to read
>>       AppArmor: cleanup generated files correctly
>>       AppArmor: kill unused macros in lsm.c
> 
> These patches are showing up here with you as the author (not the original 
> authors).  If applying raw patches, you'll need to set GIT_AUTHOR_EMAIL 
> and GIT_AUTHOR_NAME, or more simply, use git-am -s on mailbox format files 
> exported from your mailer.
> 
Ah yep sorry about that, I've reimported and pushed it up.

The following changes since commit eae61f3c829439f8f9121b5cd48a14be04df451f:

  TOMOYO: Fix memory leak upon file open. (2011-03-03 10:13:26 +1100)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jj/apparmor-dev.git security-next

John Johansen (1):
      AppArmor: Cleanup make file to remove cruft and make it easier to read

Michal Hocko (1):
      AppArmor: cleanup generated files correctly

Shan Wei (1):
      AppArmor: kill unused macros in lsm.c

 security/apparmor/Makefile |   38 +++++++++++++++++++++++++++++++++-----
 security/apparmor/lsm.c    |    2 --
 2 files changed, 33 insertions(+), 7 deletions(-)
