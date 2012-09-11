Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755627Ab2IKOXo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 10:23:44 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:62835 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020Ab2IKOXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 10:23:41 -0400
Message-ID: <504F4968.2050206@colorfullife.com>
Date: Tue, 11 Sep 2012 16:23:36 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
CC: akpm@linux-foundation.org, a.p.zijlstra@chello.nl, arnd@arndb.de,
        hughd@google.com, linux-kernel@vger.kernel.org, cmetcalf@tilera.com,
        yeohc@au1.ibm.com, linux-security-module@vger.kernel.org,
        kosaki.motohiro@jp.fujitsu.com, hpa@zytor.com, casey@schaufler-ca.com,
        eparis@parisplace.org, devel@openvz.org
Subject: Re: [PATCH v4 9/9] test: IPC message queue migration test
References: <20120813122835.5581.70057.stgit@localhost6.localdomain6> <20120813123221.5581.66540.stgit@localhost6.localdomain6>
In-Reply-To: <20120813123221.5581.66540.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stanislav,

sorry for the slow reply, I finally got the time to perform tests with 
your patches.


On 08/13/2012 02:32 PM, Stanislav Kinsbursky wrote:
> This test is a part of CRIU development test suit.
> ---
>   tools/testing/selftests/ipc/msgque.c |  151 ++++++++++++++++++++++++++++++++++
>   1 files changed, 151 insertions(+), 0 deletions(-)
>   create mode 100644 tools/testing/selftests/ipc/msgque.c
>
> diff --git a/tools/testing/selftests/ipc/msgque.c b/tools/testing/selftests/ipc/msgque.c
> new file mode 100644
> index 0000000..c101e25
> --- /dev/null
> +++ b/tools/testing/selftests/ipc/msgque.c
> @@ -0,0 +1,151 @@
> +#define _GNU_SOURCE
> +#include <sched.h>
> +
> +#include <stdio.h>
> +#include <string.h>
> +#include <stdlib.h>
> +#include <unistd.h>
> +#include <sys/types.h>
> +#include <sys/wait.h>
> +#include <sys/sem.h>
> +#include <sys/ipc.h>
> +#include <sys/msg.h>
> +#include <signal.h>
> +#include <errno.h>
> +
> +#include "zdtmtst.h"
- This file "zdtmtst.h" seems to be missing
- There is no "Makefile" in this folder
- The folder "ipc" is not aded to tools/testing/selftests/Makefile.

---
