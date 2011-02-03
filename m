Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580Ab1BCRMS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 12:12:18 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59342 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756065Ab1BCRMR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 12:12:17 -0500
Message-ID: <4D4AE1DF.9030106@zytor.com>
Date: Thu, 03 Feb 2011 09:11:59 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Kees Cook <kees.cook@canonical.com>,
        matthieu castet <castet.matthieu@free.fr>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [BUG] broken ebba638ae723d8a8fc2f7abce5ec18b688b791d7
References: <4D41E86D.8060205@free.fr> <201102031230.13759.rusty@rustcorp.com.au> <3ba4a711-ac8b-46aa-b585-51c8b9881c8c@email.android.com> <201102032032.08848.rusty@rustcorp.com.au>
In-Reply-To: <201102032032.08848.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2011 02:02 AM, Rusty Russell wrote:
> On Thu, 3 Feb 2011 01:05:44 pm H. Peter Anvin wrote:
>> Can we completely kill the "don't reload segments" flag, then?
> 
> We can as far as *I* am concerned, but of course it's a separate issue...

I'm trying to figure out if there is any actual user of it.  I thought
it was Xen which needed it, but Jeremy says it doesn't; I don't know
what else would possible need it.  If it is is something that isn't used
then it would be better to get rid of it.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

