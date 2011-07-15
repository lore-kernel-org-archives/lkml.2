Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996Ab1GONSg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 09:18:36 -0400
Received: from DMZ-MAILSEC-SCANNER-8.MIT.EDU ([18.7.68.37]:52644 "EHLO
	dmz-mailsec-scanner-8.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751683Ab1GONSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 09:18:34 -0400
X-Greylist: delayed 300 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Jul 2011 09:18:34 EDT
X-AuditID: 12074425-b7bcaae000000a1b-ce-4e203cd5289d
Subject: Re: [PATCH 1/2] Kconfig: Allow disabling of CONFIG_DEVPORT
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Theodore Tso <tytso@MIT.EDU>
In-Reply-To: <20110715064147.GA1021@suse.de>
Date: Fri, 15 Jul 2011 09:13:27 -0400
Cc: Mike Waychison <mikew@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <C70E3912-6AA9-4EB3-85CC-11BF90D230C8@mit.edu>
References: <1310675693-9204-1-git-send-email-mikew@google.com> <20110714212113.GA28639@suse.de> <CAGTjWtB53vW5B2EJ5=+C3buDAY0RtsfANxx5NhC5aWnmEx08EQ@mail.gmail.com> <20110715064147.GA1021@suse.de>
To: Greg KH <gregkh@suse.de>
X-Mailer: Apple Mail (2.1084)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIKsWRmVeSWpSXmKPExsUixG6nonvVRsHP4PtOVYs569ewWfz5uYnV
	YtpGcYvLu+awWex4u5jZ4tKBBUwWmzdNZbb4seExqwOHx4JNpR6bVnWyebw7d47d48SM3ywe
	7/ddZfPYfLra4/MmOY8TLV9YAziiuGxSUnMyy1KL9O0SuDLef3zIXvCTuaL94z3GBsYJzF2M
	nBwSAiYSa9rbWCBsMYkL99azdTFycQgJ7GOUmPb3CjOEs4FRYv60KewgVUICp5kkdj7IBLGF
	BZwlXl1oZwSxeQUMJZZuagerYRbQkrjx7yUTiM0moCRx59N+sA2cAjoS+x8vB9vMIqAq8XTG
	B3aQBcwCXUwSU5f9Y4NolpfY/nYOM8RQK4n/V/6wQ1xxlFFixbubYJNEBGQkvhw7DrSZA+hu
	WYmmZRkTGAVnIbljFpI7ZiEZu4CReRWjbEpulW5uYmZOcWqybnFyYl5eapGuhV5uZoleakrp
	JkZwzLio7mCccEjpEKMAB6MSD6+huLyfEGtiWXFl7iFGSQ4mJVHej9YKfkJ8SfkplRmJxRnx
	RaU5qcWHGCU4mJVEePOYgHK8KYmVValF+TApaQ4WJXHeEO//vkIC6YklqdmpqQWpRTBZGQ4O
	JQneQmBqEBIsSk1PrUjLzClBSDNxcIIM5wEang1Sw1tckJhbnJkOkT/FqCglzmsPkhAASWSU
	5sH1wlLaK0ZxoFeEeZNAqniA6RCu+xXQYCagweusZEEGlyQipKQaGCfmBDEd/6elXS2psF1J
	efPCwxNLjduqhVYu7H5h4D3XQ3bL7B6haSr5tr7TK/KD+05N36oXZuR26vt+EXsD3+3/rq+4
	sFQx7RN3yzuf2t4Pf+8F8raZ69X1lGVdSrCw0Zd3WKx14ihblOanEIYy41fXbO8tiD12Infe
	lBXcUYrFWk3b2UwtlFiKMxINtZiLihMBzDTPpEQDAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 15, 2011, at 2:41 AM, Greg KH wrote:

> 
> Ok, but what happens if all 2000+ different companies start adding their
> fields to the signed-off-by: area of the kernel for their internal
> tracking systems?

That's been happening for a long time; there have been kernel patches
referencing LTC, RHEL, and SLES bugzilla entries; many of those
bug entries are not public so as not to reveal customer confidential
information.   I've never seen anyone complain about that before.

-- Ted

