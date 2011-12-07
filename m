Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697Ab1LGJfT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 04:35:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42767 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751305Ab1LGJfQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 04:35:16 -0500
Message-ID: <4EDF3347.3030601@redhat.com>
Date: Wed, 07 Dec 2011 17:35:03 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Please add my tree to linux-next
References: <4ED8529E.5070608@redhat.com>	<20111205100930.1bedc458a5e78b85c563465d@canb.auug.org.au>	<4EDC594D.5040008@redhat.com> <20111205171207.3b3bc1ad6d99ad7d7c9c0792@canb.auug.org.au> <4EDC6A42.1090806@redhat.com>
In-Reply-To: <4EDC6A42.1090806@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Stephen,

I just re-commit those patches into my tree with ACK's I got,
and squash a patch which fixes ARM build, so it is rebased now.
Please re-add it to linux-next.

git://github.com/congwang/linux.git #kmap_atomic

Thanks!
