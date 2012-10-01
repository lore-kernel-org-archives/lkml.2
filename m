Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908Ab2JAWAt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 18:00:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50712 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752605Ab2JAWAs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 18:00:48 -0400
Message-ID: <506A1279.6030309@zytor.com>
Date: Mon, 01 Oct 2012 15:00:25 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Pierre Beck <mail@pierre-beck.de>,
        linux-kernel@vger.kernel.org
Subject: Re: 3.6-rc7 32-bit PAE miscalculates dirty page limits
References: <5068130A.4050602@pierre-beck.de> <506894D5.5060101@zytor.com> <506A06B6.50800@pierre-beck.de> <20121001215202.GB19126@liondog.tnic> <506A10E4.80905@zytor.com> <20121001215936.GC19126@liondog.tnic>
In-Reply-To: <20121001215936.GC19126@liondog.tnic>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2012 02:59 PM, Borislav Petkov wrote:
> On Mon, Oct 01, 2012 at 02:53:40PM -0700, H. Peter Anvin wrote:
>> It is very sad, though, that there are still drivers which don't work
>> correctly in compat mode. Please report bugs on those -- that is just
>> not acceptable.
>>
>> Unfortunately few distros provide 64-bit kernels for their 32-bit
>> distros, which acerbates the problem.
> 
> Yes, the other way 'round, 32-bit userspace on 64-bit kernels should
> work. And fixed if not.
> 

That is the same way around (32-bit kernel, 64-bit userspace obviously
is a nonstarter.)

	-hpa

