Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759234Ab2CMFnI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 01:43:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35821 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755283Ab2CMFnG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 01:43:06 -0400
Message-ID: <4F5EDE5B.7070207@zytor.com>
Date: Mon, 12 Mar 2012 22:42:51 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: CAI Qian <caiqian@redhat.com>, Takashi Iwai <tiwai@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Vivek Goyal <vgoyal@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: crash dump memory reservation regression
References: <5535e246-b7c0-4f69-a27b-1abbadd42db0@zmail14.collab.prod.int.phx2.redhat.com> <65a23329-d843-4859-8b7b-430f12882492@zmail14.collab.prod.int.phx2.redhat.com> <CAE9FiQU9C=5YAa3DPcx8E9yVckSX5JbLdS=TC90jA8wz1pjzmw@mail.gmail.com>
In-Reply-To: <CAE9FiQU9C=5YAa3DPcx8E9yVckSX5JbLdS=TC90jA8wz1pjzmw@mail.gmail.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2012 10:31 PM, Yinghai Lu wrote:
> 
> Solution will be:
> 1.  remove the good_end setting for 64 bit again. and root cause S4 resume.

This would by far be the best.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

