Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629Ab2L0E32 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 23:29:28 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:54660 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912Ab2L0E3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 23:29:25 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>
References: <50DBC2E0.3040908@huawei.com>
Date: Wed, 26 Dec 2012 20:29:15 -0800
In-Reply-To: <50DBC2E0.3040908@huawei.com> (Li Zefan's message of "Thu, 27 Dec
	2012 11:39:12 +0800")
Message-ID: <87vcbo15k4.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+rCea7Ej6CfKt8V2ctHGf4hrLggmVkN1Q=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0019]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Li Zefan <lizefan@huawei.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] userns: Allow unprivileged reboot
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan <lizefan@huawei.com> writes:

> In a container with its own pid namespace and user namespace, rebooting
> the system won't reboot the host, but terminate all the processes in
> it and thus have the container shutdown, so it's safe.
>
> Signed-off-by: Li Zefan <lizefan@huawei.com>

Applied to my development tree.  It will eventaully make it to my
for-next branch.

Eric
