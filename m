Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758344Ab0G3CEr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 22:04:47 -0400
Received: from adelie.canonical.com ([91.189.90.139]:45257 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755805Ab0G3CEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 22:04:46 -0400
Message-ID: <4C523336.2020504@canonical.com>
Date: Thu, 29 Jul 2010 19:04:38 -0700
From: John Johansen <john.johansen@canonical.com>
Organization: Canonical
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
CC: jmorris@namei.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: Re: [AppArmor #7 0/13] AppArmor security module
References: <1280440089-3203-1-git-send-email-john.johansen@canonical.com>	<alpine.LRH.2.00.1007300903440.7719@tundra.namei.org> <201007301045.BFG35946.OSQFJFOHtFLVMO@I-love.SAKURA.ne.jp>
In-Reply-To: <201007301045.BFG35946.OSQFJFOHtFLVMO@I-love.SAKURA.ne.jp>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2010 06:45 PM, Tetsuo Handa wrote:
> James Morris wrote:
>> Applied to
>> git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next
> 
> Congratulations!
> 
thanks, and thankyou for all the reviewing you did

> By the way, security/apparmor/Kconfig and security/apparmor/Makefile seems to be missing...

hrmm,

[PATCH 12/13] AppArmor: Enable configuring and building of the AppArmor security module

Kconfig and Makefiles to enable configuration and building of AppArmor.

Signed-off-by: John Johansen <john.johansen@canonical.com>
---
 security/Kconfig             |    6 ++++++
 security/Makefile            |    2 ++
 security/apparmor/.gitignore |    5 +++++
 security/apparmor/Kconfig    |   31 +++++++++++++++++++++++++++++++
 security/apparmor/Makefile   |   24 ++++++++++++++++++++++++
 5 files changed, 68 insertions(+), 0 deletions(-)

...
