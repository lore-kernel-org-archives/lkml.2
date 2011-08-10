Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001Ab1HJQUY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 12:20:24 -0400
Received: from DMZ-MAILSEC-SCANNER-2.MIT.EDU ([18.9.25.13]:60806 "EHLO
	dmz-mailsec-scanner-2.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751709Ab1HJQUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 12:20:23 -0400
X-AuditID: 1209190d-b7be0ae000000a16-62-4e42af2020f1
Message-ID: <4E42AFBE.7000502@mit.edu>
Date: Wed, 10 Aug 2011 12:20:14 -0400
From: Andy Lutomirski <luto@MIT.EDU>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Keith Packard <keithp@keithp.com>
CC: Dave Airlie <airlied@linux.ie>,
        Intel drivers <Intel-gfx@lists.freedesktop.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, stable@kernel.org
Subject: Re: [PULL] drm-intel-next
References: <yunhb5xlvfy.fsf@aiko.keithp.com>
In-Reply-To: <yunhb5xlvfy.fsf@aiko.keithp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGKsWRmVeSWpSXmKPExsUixG6nrquw3snPYOdNFovecyeZLK58fc9m
	MXvCZiaLJd9ms1tc3jWHzeLT+QtsDmwetz5+ZfPYtKqTzWP7twesHve7jzN5fN4kF8AaxWWT
	kpqTWZZapG+XwJXxYMNttoJXLBXNb5sZGxjvMXcxcnJICJhITNi4jw3CFpO4cG89mC0ksI9R
	4lQHbxcjF5C9gVHi++XD7BCJt0wS376EgNi8AmoSS54dYO1i5OBgEVCV2LqaESTMJqAi0bH0
	AROILSoQJHH/dwMLRLmgxMmZT8BsEaDyo1PaWUDmMwucZ5RoP9kPtlhYQEniZOt9JohduhJn
	n10Am88poCex82IpiMksYC3xbXcRSAWzgLzE9rdzmCcwCs5CsmEWQtUsJFULGJlXMcqm5Fbp
	5iZm5hSnJusWJyfm5aUW6Rrp5WaW6KWmlG5iBAU/pyTvDsZ3B5UOMQpwMCrx8DKtdvITYk0s
	K67MPcQoycGkJMoruw4oxJeUn1KZkVicEV9UmpNafIhRgoNZSYRXah5QjjclsbIqtSgfJiXN
	waIkzlu4w8FPSCA9sSQ1OzW1ILUIJivDwaEkwSsEjHIhwaLU9NSKtMycEoQ0EwcnyHAeoOHM
	IDW8xQWJucWZ6RD5U4yKUuK8siAJAZBERmkeXC8sOb1iFAd6RZiXHaSKB5jY4LpfAQ1mAhpc
	f8cBZHBJIkJKqoGROb+0dp3NOZXqvbeDF3bUaM7PZJ5ab2AafCnhz6/EBSJZEl2TBVxWb120
	X6o3Ia+tcCbjrfrHK46zG6nvVY3jY941e7L55YI94ZKvutJufpY8O2kO81Q1eSfX8388+lXu
	Gc6KWCTwudW3x75PiOmHePDSyiPbnq2vnfZ3x7xNehOygyzWdR1QYinOSDTUYi4qTgQAkNCa
	kCkDAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2011 11:14 PM, Keith Packard wrote:
>
> Here's a pile of fixes on top of the stuff already in drm-core-next.
>
>   * Pile of mode setting fixes which eliminate a selection of bugs and
>     other annoyances. Eliminates the 'stripey' effect when going from
>     two to one monitor, makes hot-plug work after suspend/resume, turns
>     off the pipe/plane in DPMS off.

Can you ack at least this one:

>        Revert and fix "drm/i915/dp: remove DPMS mode tracking from DP"
(i.e. d2b996ac698aebb28557355857927b8b934bb4f9)

for -stable?  It fixes an annoying regression in 3.0.

Thanks,
Andy
