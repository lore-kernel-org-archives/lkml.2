Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256Ab1JLPKt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 11:10:49 -0400
Received: from mail-dy0-f46.google.com ([209.85.220.46]:38933 "EHLO
	mail-dy0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104Ab1JLPKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 11:10:47 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: Christoph Hellwig <hch@infradead.org>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, jack@suse.cz, akpm@linux-foundation.org,
        toshi.okajima@jp.fujitsu.com
Subject: Re: [PATCH 0/13] read-only remount race fix v7
References: <1318430946-7091-1-git-send-email-miklos@szeredi.hu>
	<20111012150332.GA25289@infradead.org>
Date: Wed, 12 Oct 2011 17:09:56 +0200
In-Reply-To: <20111012150332.GA25289@infradead.org> (Christoph Hellwig's
	message of "Wed, 12 Oct 2011 11:03:32 -0400")
Message-ID: <8739eyw8jf.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=

Christoph Hellwig <hch@infradead.org> writes:

> On Wed, Oct 12, 2011 at 04:48:53PM +0200, Miklos Szeredi wrote:
>> Here's an update of the read-only remount race fixes.
>> 
>> It should now fix the races after unlink.  I haven't been able to
>> trigger the bad behavior with the test scripts provided by Toshiyuki
>> Okajima.
>
> How does the test script look like?  Could we integrate it into xfstests
> so that we have a good regular run regression test for this?

Attaching the scripts.  It doesn't detect failure, currenly that needs
to be derived from the output of the run and dmesg.

Thanks,
Miklos


--=-=-=
Content-Type: application/x-shellscript
Content-Disposition: inline; filename=go.sh
Content-Transfer-Encoding: base64

IyEvYmluL3NoCgpkZCBpZj0vZGV2L3plcm8gb2Y9L3RtcC9pbWcgYnM9MWsgY291bnQ9MSBzZWVr
PTEwMDBrID4gL2Rldi9udWxsIDI+JjEKL3NiaW4vbWtmcy5leHQ0IC1GcSAvdG1wL2ltZwptb3Vu
dCAtbyBsb29wIC90bXAvaW1nIC9tbnQKLi93cml0ZXIuc2ggL21udCAmCkxPT1A9MTAwMDAwMDAw
MApmb3IgKChpPTA7IGk8TE9PUDsgaSsrKSk7CmRvCiAgICAgICAgZWNobyAiWyRpXSIKICAgICAg
ICBpZiAoKGklMiA9PSAwKSk7CiAgICAgICAgdGhlbgogICAgICAgICAgICAgICAgbW91bnQgLW8g
cm8scmVtb3VudCxsb29wIC9tbnQKICAgICAgICBlbHNlCiAgICAgICAgICAgICAgICBtb3VudCAt
byBydyxyZW1vdW50LGxvb3AgL21udAogICAgICAgIGZpCiAgICAgICAgc2xlZXAgMQpkb25lCg==
--=-=-=
Content-Type: application/x-shellscript
Content-Disposition: inline; filename=writer.sh
Content-Transfer-Encoding: base64

IyEvYmluL3NoCgpkaXI9JDEKZm9yICgoaT0wO2k8MTAwMDAwMDA7aSsrKSk7CmRvCiAgICAgICAg
Zm9yICgoaj0wO2o8NjQ7aisrKSk7CiAgICAgICAgZG8KICAgICAgICAgICAgICAgIGZpbGVuYW1l
PSIkZGlyL2ZpbGUkKChpKjY0ICsgaikpIgogICAgICAgICAgICAgICAgZGQgaWY9L2Rldi96ZXJv
IG9mPSRmaWxlbmFtZSBicz0xayBjb3VudD04ID4gL2Rldi9udWxsIDI+JjEgJgogICAgICAgIGRv
bmUKICAgICAgICBmb3IgKChqPTA7ajw2NDtqKyspKTsKICAgICAgICBkbwogICAgICAgICAgICAg
ICAgZmlsZW5hbWU9IiRkaXIvZmlsZSQoKGkqNjQgKyBqKSkiCiAgICAgICAgICAgICAgICBybSAt
ZiAkZmlsZW5hbWUgPiAvZGV2L251bGwgMj4mMSAmCiAgICAgICAgZG9uZQogICAgICAgIHdhaXQK
ICAgICAgICBpZiAoKGklMTAwID09IDAgJiYgaSA+IDApKTsKICAgICAgICB0aGVuCiAgICAgICAg
ICAgICAgICBybSAtZiAkZGlyL2ZpbGUqCiAgICAgICAgZmkKZG9uZQpleGl0Cg==
--=-=-=--
