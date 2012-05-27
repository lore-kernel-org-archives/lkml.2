Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751575Ab2E0XXQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 19:23:16 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:63091 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751014Ab2E0XXP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 19:23:15 -0400
MIME-Version: 1.0
In-Reply-To: <CAFLxGvzZeNxQSHQRCzYiT+OkFO1fooGfANPMYs-sSB-eQtCcpA@mail.gmail.com>
References: <87hav8vypc.fsf@xmission.com>
	<CAFLxGvzZeNxQSHQRCzYiT+OkFO1fooGfANPMYs-sSB-eQtCcpA@mail.gmail.com>
Date: Mon, 28 May 2012 01:23:13 +0200
Message-ID: <CAFLxGvx2D=W0ex1oUJrmRmoAEdug99qPP_99giGVeVe=jmgZkA@mail.gmail.com>
Subject: Re: [GIT PULL] user namespace enhancements for Linux 3.5-rc1
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "Serge E. Hallyn" <serge@hallyn.com>,
        Linux Containers <containers@lists.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 27, 2012 at 9:07 PM, richard -rw- weinberger
<richard.weinberger@gmail.com> wrote:
> On Tue, May 22, 2012 at 8:48 PM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
>> - Capabilities are localized to the current user namespace making it
>>  safe to give the initial user in a user namespace all capabilities.
>
> Today I've tried your patch set, but it looks like a root-user in a
> Linux container is still able to use /proc/sysrq-trigger.
> Am I misunderstanding user namespaces or is there still something missing?

Please ignore the above mail.
My .config was messed up. :-\

-- 
Thanks,
//richard
