Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933188Ab0J0Pai (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 11:30:38 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64838 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301Ab0J0Pag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 11:30:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=EG5b8BjOwnpDxssM9CHdwb+rboyZzZ+TQJQmcNVkZx00g9wfBqXjhVNf4mD2r9N4NS
         NBDhNKPrebb2A3T58ktkAECxWri1qDQzp3Q/8PmrZL31CNvpIPIoFRJA/eXuZzaXnJ56
         0zQxOybT2ZTD9CltQEHMbYxNMp7A2mFLozQ10=
Message-ID: <4CC84597.4000204@gmail.com>
Date: Wed, 27 Oct 2010 17:30:31 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.12) Gecko/20101026 SUSE/3.1.6 Thunderbird/3.1.6
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL for 2.6.37-rc1] V4L/DVB updates
References: <4CC8380D.3040802@redhat.com>
In-Reply-To: <4CC8380D.3040802@redhat.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2010 04:32 PM, Mauro Carvalho Chehab wrote:
> Linus,
> 
> Please pull from
> 	ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git v4l_for_linus
...
> Mauro Carvalho Chehab (72):
...
>       [media] tda18271: allow restricting max out to 4 bytes

Even though you know this one breaks at least one driver you want it merged?

regards,
-- 
js
