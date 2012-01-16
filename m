Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753700Ab2APIyR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 03:54:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47013 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753464Ab2APIyQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 03:54:16 -0500
Message-ID: <4F13E5AF.3080805@redhat.com>
Date: Mon, 16 Jan 2012 09:54:07 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: dgilbert@interlog.com
CC: linux-kernel@vger.kernel.org, Petr Matousek <pmatouse@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        James Bottomley <JBottomley@parallels.com>
Subject: Re: [PATCH v2 0/3] possible privilege escalation via SG_IO ioctl
 (CVE-2011-4127)
References: <1326380489-9044-1-git-send-email-pbonzini@redhat.com> <4F13779E.1070807@interlog.com>
In-Reply-To: <4F13779E.1070807@interlog.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2012 02:04 AM, Douglas Gilbert wrote:
>>
>>
>> Tested on top of 3.2 + Linus's patch to sanitize ioctl return values.
>
> Is that a fixed version of patch at the end of this post:
> http://marc.info/?l=linux-kernel&m=132578310403616&w=2
> The fix being
>    s/ENOIOCTLCMD/-ENOIOCTLCMD/
> in is_unrecognized_ioctl() ?

Yes.  I cherry-picked it from Linus's tree.

> Also could you post "PATCH v2 3/3 ..." to this list as well so
> we have a complete set?

FWIW, 3/3 only touches LVM.

Paolo
