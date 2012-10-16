Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870Ab2JPH0r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 03:26:47 -0400
Received: from relay.parallels.com ([195.214.232.42]:37502 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754244Ab2JPH0p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 03:26:45 -0400
Message-ID: <507D0C29.8060209@parallels.com>
Date: Tue, 16 Oct 2012 11:26:33 +0400
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "criu@openvz.org" <criu@openvz.org>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "gorcunov@openvz.org" <gorcunov@openvz.org>,
        "devel@openvz.org" <devel@openvz.org>
Subject: Re: [PATCH] proc: check vma->vm_file before dereferencing
References: <20121015152957.24859.7960.stgit@localhost.localdomain> <20121015144048.8fa16d28.akpm@linux-foundation.org>
In-Reply-To: <20121015144048.8fa16d28.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

16.10.2012 01:40, Andrew Morton пишет:
> On Mon, 15 Oct 2012 19:30:03 +0400
> Stanislav Kinsbursky <skinsbursky@parallels.com> wrote:
>
>> It can be equal to NULL.
>>
>
> Please write better changelogs, so people do not have to ask questions
> such as:
>
> - Under what conditions does this bug trigger?
>
> - In which kernel version(s)?
>
> - Is it a post-3.6 regression?
>

Sure. Sorry.

> Thanks.
>


-- 
Best regards,
Stanislav Kinsbursky
