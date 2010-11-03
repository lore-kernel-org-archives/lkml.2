Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499Ab0KCWrX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 18:47:23 -0400
Received: from cantor.suse.de ([195.135.220.2]:42713 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751323Ab0KCWrU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 18:47:20 -0400
Message-ID: <4CD1E679.5080202@suse.cz>
Date: Wed, 03 Nov 2010 23:47:21 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, kyle@redhat.com,
        lacombar@gmail.com, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: REGRESSION: Re: [GIT] kconfig rc fixes
References: <20101009224041.GA901@sepie.suse.cz> <4CD1E232.30406@redhat.com>
In-Reply-To: <4CD1E232.30406@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3.11.2010 23:29, Mauro Carvalho Chehab wrote:
> Em 09-10-2010 18:40, Michal Marek escreveu:
>> The following changes since commit cb655d0f3d57c23db51b981648e452988c0223f9:
>>
>>   Linux 2.6.36-rc7 (2010-10-06 13:39:52 -0700)
>>
>> are available in the git repository at:
>>   git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild-2.6.git rc-fixes
>>
>> Arnaud Lacombe (1):
>>       kconfig: delay symbol direct dependency initialization
> 
> This patch generated a regression with V4L build. After applying it, some Kconfig
> dependencies that used to work with V4L Kconfig broke.

You mean, the dependencies trigger a warning now, right? Also, you are
replying to my pull request for 2.6.36-rc8, but that pull request also
included "kconfig: Temporarily disable dependency warnings", so 2.6.36
final is NOT affected by this, just to clarify. 2.6.37-rc1 reverted this
workaround and I hope we come to some solution now. BTW,
http://www.kerneltrap.com/mailarchive/linux-kernel/2010/10/7/4629122/thread
is how a very similar issue was fixed in the i2c Kconfig (commit 0a57274
in 2.6.37-rc1 now).

Michal
