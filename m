Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602Ab1HSRZN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 13:25:13 -0400
Received: from void.printf.net ([89.145.121.20]:36425 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756355Ab1HSRZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 13:25:10 -0400
From: Chris Ball <cjb@laptop.org>
To: Per Forlin <per.forlin@linaro.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, akpm@linux-foundation.org,
        Linus Walleij <linus.ml.walleij@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        linaro-dev@lists.linaro.org, linux-mm@kvack.org
Subject: Re: [PATCH --mmotm v8 0/3] Make fault injection available for MMC IO
References: <1312891671-28680-1-git-send-email-per.forlin@linaro.org>
	<CAJ0pr1-8Jnk1CKakWcS6T4Q3bAe7sF=5p8+9ou1+SbxsZM_Svw@mail.gmail.com>
Date: Fri, 19 Aug 2011 13:24:55 -0400
In-Reply-To: <CAJ0pr1-8Jnk1CKakWcS6T4Q3bAe7sF=5p8+9ou1+SbxsZM_Svw@mail.gmail.com>
	(Per Forlin's message of "Fri, 19 Aug 2011 11:53:44 +0200")
Message-ID: <m2pqk1mhzs.fsf@bob.laptop.org>
User-Agent: Gnus/5.110018 (No Gnus v0.18) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Per,

On Fri, Aug 19 2011, Per Forlin wrote:
> Hi Chris,
>
> It's no longer necessary to merge this through the mm-tree since
> Akinobu's patch "fault-injection: add ability to export fault_attr in
> arbitrary directory" is in mainline.
> Chris, would you mind merging the fault-injection patches in this
> patchset to mmc-next once the mmc part of this patchset is acked and
> accepted?

That's fine -- merged to mmc-next for 3.2 now, with Linus W's review.

Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
