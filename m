Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754488Ab0EVORL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 10:17:11 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:40262 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725Ab0EVORI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 10:17:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=mFo7di6DY/XWB2qSA9omKWuAxYugGYbmAk3TF++gQ0/ngF8KE6UiJ6BPnz85brRMtD
         Oj6GPddFaHlD8NEhIqtbt42je/e81xOsigZ2Gm4o3d+oe6MdnZPO7jjU2cs5ERfkMfup
         344JElq+k6FZQAJ69BmjznykmBcC1H0NvVjLs=
Message-ID: <4BF7E769.1090102@gmail.com>
Date: Sat, 22 May 2010 07:17:13 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: piotr@hosowicz.com
CC: Randy Dunlap <rdunlap@xenotime.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-kernel@vger.kernel.org
Subject: Re: What's up with wireless drivers?
References: <4BF6F2E4.5030800@example.com>	<20100521210729.GC2495@tuxdriver.com>	<4BF6F959.5040401@example.com>	<4BF6FBB0.6060407@example.com> <20100521151203.f94c1d3e.rdunlap@xenotime.net> <4BF7073A.4090506@example.com> <4BF7986C.4030505@example.com> <4BF7D185.2040705@example.com> <4BF7D86B.3020204@example.com> <4BF7DDAA.1080307@gmail.com> <4BF7DEE7.9010801@example.com> <4BF7DFDA.3000604@gmail.com> <4BF7E470.6080409@example.com>
In-Reply-To: <4BF7E470.6080409@example.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2010 07:04 AM, Piotr Hosowicz wrote:
> On 22.05.2010 15:44, Justin P. Mattock wrote:
>
>> what about strace make
>> (maybe will give you info)
>
> May be I'll try like that if the problem persists. I will produce tons
> of output I believe :-(
>


yeah it does,
you can always send the
output to a file i.g.
strace -o filename make
anything at this point though
to see what is crapping out

Justin P. Mattock
