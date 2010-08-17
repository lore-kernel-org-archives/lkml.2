Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184Ab0HQGrG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 02:47:06 -0400
Received: from cantor.suse.de ([195.135.220.2]:54041 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755590Ab0HQGrF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 02:47:05 -0400
Message-ID: <4C6A2FC2.9050908@suse.cz>
Date: Tue, 17 Aug 2010 08:44:18 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100520 SUSE/3.0.5 Thunderbird/3.0.5
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
Cc: Mike Frysinger <vapier@gentoo.org>, linux-kbuild@vger.kernel.org,
        Roman Zippel <zippel@linux-m68k.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kconfig: fix warnings in fgets/fwrite usage
References: <1281592579-343-1-git-send-email-vapier@gentoo.org> <20100817054640.GD5095@cr0.nay.redhat.com>
In-Reply-To: <20100817054640.GD5095@cr0.nay.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17.8.2010 07:46, Américo Wang wrote:
> On Thu, Aug 12, 2010 at 01:56:19AM -0400, Mike Frysinger wrote:
>> Add some helper functions that abort on failure, and change the fwrite
>> and fget calls to use those.  This should kill off all the ugly gcc
>> warnings that some distros emit about ignoring return values due to
>> usage of warn_unused_result attributes.
>>
>> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> 
> Looks good to me,
> 
> Acked-by: WANG Cong <xiyou.wangcong@gmail.com>

I already merged similar patches by Jean Sacren, see commits bf5e327 and
4418a2b in kbuild-2.6.git.

Michal
