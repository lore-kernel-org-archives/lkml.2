Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326Ab1BGUvn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 15:51:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41067 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754091Ab1BGUvm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 15:51:42 -0500
Message-ID: <4D505B5A.1000203@redhat.com>
Date: Mon, 07 Feb 2011 21:51:38 +0100
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101213 Thunderbird/3.1.7
MIME-Version: 1.0
To: "Ted Ts'o" <tytso@mit.edu>, Matt <jackdachef@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>
Subject: Re: ext4: Fix data corruption with multi-block writepages support
References: <AANLkTi=gcf=A_6Kp6h7s2+OkxR4YUb6gqzc43asn-wfK@mail.gmail.com> <20110207174552.GC3457@thunk.org> <4D503A06.3010403@redhat.com> <20110207204419.GE3457@thunk.org>
In-Reply-To: <20110207204419.GE3457@thunk.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2011 09:44 PM, Ted Ts'o wrote:
> So the fact that we found and fixed an ext4 bug that was triggered by
> dm_crypt should not be taken as a statement (one way or the other)
> that dm_crypt is Bug-Free(tm).  :-)

Really? Sigh. ;-)

(There is a rule that if dm-crypt+XFS bug appears, the problem
is always in dm-crypt. So I am quite surprised that this time there
was NO bug in dm-crypt... yet :-)

Anyway, I would like to know if still some problem remains...

Thanks,
Milan
