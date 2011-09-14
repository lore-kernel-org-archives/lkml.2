Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819Ab1INBpK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 21:45:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49705 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753488Ab1INBpI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 21:45:08 -0400
Message-ID: <4E7007F3.9080305@suse.cz>
Date: Wed, 14 Sep 2011 03:48:35 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC] Kbuild: allow code re-use across different directories
References: <1313800642-32418-1-git-send-email-lacombar@gmail.com> <4E6A0700.9030401@suse.cz> <CACqU3MUfJAeur_65i5vDegu1d1VqAdq15EedfX9A3w52J23MPg@mail.gmail.com>
In-Reply-To: <CACqU3MUfJAeur_65i5vDegu1d1VqAdq15EedfX9A3w52J23MPg@mail.gmail.com>
X-Enigmail-Version: 1.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 13.9.2011 23:13, Arnaud Lacombe napsal(a):
> 2011/9/9 Michal Marek <mmarek@suse.cz>:
>> On 20.8.2011 02:37, Arnaud Lacombe wrote:
>>> With the attached patch, we would do:
>>>
>>> arch/foo/boot/Makefile:
>>> LDFLAGS_fancy.o := -DPANTS=30
>>> obj-y += fancy.o
>>> vpath-y += $(srctree)/arch/foo/lib
>>>
>>> and let GNU make do the job.
>>
>> I like this. The only issue I can think of right now, is that if you add
>> a large directory to vpath-y, then it would be easy to accidentally
>> reuse more files from that directory than intended. But that could be
>> easily prevented by isolating those reusable source files.
>>
> I do not think it is that dangerous. We enforce unique access to VPATH
> and we still prioritize $(src) over any other specified path.
> 
> That said, what would you want to pull the patch into -next, beside
> kernel.org being up ?

Just post it with a proper signoff. But there won't be any linux-next
until kernel.org is back again.

Michal
