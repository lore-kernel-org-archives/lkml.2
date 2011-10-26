Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933248Ab1JZOb5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 10:31:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1029 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932772Ab1JZObz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 10:31:55 -0400
Message-ID: <4EA819CC.100@redhat.com>
Date: Wed, 26 Oct 2011 16:31:40 +0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Mike Frysinger <vapier@gentoo.org>
CC: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Kamil Debski <k.debski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH] [media] v4l2: punt generated pdf files
References: <1319635477-9383-1-git-send-email-vapier@gentoo.org> <CAMjpGUfEtLSiJoYG+42aFLnx83Zmzd88MAU1DVYXcBxTpo3wSw@mail.gmail.com>
In-Reply-To: <CAMjpGUfEtLSiJoYG+42aFLnx83Zmzd88MAU1DVYXcBxTpo3wSw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 26-10-2011 15:33, Mike Frysinger escreveu:
> On Wed, Oct 26, 2011 at 09:24, Mike Frysinger wrote:
>> These don't belong in the tree, and we have a .gitignore on them already
>> (not sure how these slipped in), so punt the compiled files.
> 
> hrm, i thought default git send-email/format-patch didn't include
> binary updates when deleting in the diff.  not sure what's going on
> here.  i can resend if people want with the -D flag.

Nah, not needed. I'll fix the patch when merging it. I probably won't
be merging this week, as this notebook has not enough power to compile
the Kernel (and I received a series of 100+ patches on those days).

Thanks,
Mauro

