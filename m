Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289Ab2HCM7G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 08:59:06 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:59112 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919Ab2HCM7C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 08:59:02 -0400
References: <alpine.LFD.2.02.1203231926000.2542@ionos> <20120323190855.GA27213@www.outflux.net> <CAFLxGvzPVPyXPwjay4a01q1vx4K4Ht56bHjzswYrr1wvB_1dYw@mail.gmail.com> <87pq7935w2.fsf@xmission.com> <CAFLxGvz0reQS=zfWeTz4a4xZVFeeu80VnP-efy7zCiPZVWzH-g@mail.gmail.com> <20120803110247.GB11952@moon> <501BC62A.4090308@parallels.com>
User-Agent: K-9 Mail for Android
In-Reply-To: <501BC62A.4090308@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
From: "Eric W. Biederman" <ebiederm@xmission.com>
Date: Fri, 03 Aug 2012 05:58:45 -0700
To: Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        richard -rw- weinberger <richard.weinberger@gmail.com>
CC: Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Darren Hart <dvhart@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, David Howells <dhowells@redhat.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "kernel-hardening@lists.openwall.com" 
	<kernel-hardening@lists.openwall.com>,
        "spender@grsecurity.net" <spender@grsecurity.net>
Message-ID: <e80f32ef-d6cf-48cc-9ddb-75d95bc9581e@email.android.com>
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/hijuTWo3tdt0PS2m4DURshqN9fe1FnhA=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Pavel Emelyanov <xemul@parallels.com>,Cyrill Gorcunov
	<gorcunov@openvz.org>,richard -rw- weinberger <richard.weinberger@gmail.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH v2] futex: mark get_robust_list as deprecated
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The permissions on the syscall were fixed them withR ptrace_may_access.

We have identified two legitimate use cases.

It looks like it is time for someone to generate the path to remove the depreciation.

Who is up for writing and testing that patch?

Eric

