Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415Ab2AYBOY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 20:14:24 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:59539 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755138Ab2AYBOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 20:14:23 -0500
Message-ID: <4F1F576A.9090102@gmail.com>
Date: Tue, 24 Jan 2012 20:14:18 -0500
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [patch 1/4] fs, proc: Introduce /proc/<pid>/task/<tid>/children
 entry v8
References: <20120123142036.025893883@openvz.org> <20120123142436.181674896@openvz.org> <20120124110730.a3536647.kamezawa.hiroyu@jp.fujitsu.com> <20120124065338.GB29735@moon> <20120124160709.e05c51b5.kamezawa.hiroyu@jp.fujitsu.com> <20120124072122.GD29735@moon> <m1boptmqj0.fsf@fess.ebiederm.org> <20120124091135.GI29735@moon>
In-Reply-To: <20120124091135.GI29735@moon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(1/24/12 4:11 AM), Cyrill Gorcunov wrote:
> On Tue, Jan 24, 2012 at 12:52:03AM -0800, Eric W. Biederman wrote:
>> Cyrill Gorcunov<gorcunov@gmail.com>  writes:
>>
>>> On Tue, Jan 24, 2012 at 04:07:09PM +0900, KAMEZAWA Hiroyuki wrote:
>>>>>
>>>>> Hmm. But userspace app will get eof, so frankly I don't see
>>>>> a problem here. Or maybe I miss something?
>>>>>
>>>>
>>>> Userspace need to take care of whether there may be"\n" or not even
>>>> if read() returns EOF.
>>>> As an interface, it's BUG to say "\n" will be there if you're lucky!"
>>>> (*) I know script language can handle this but we shouldn't assume that.
>>>>
>>>> How about just remove "\n" at EOF  ? I think it's unnecessary.
>>>>
>>>
>>> Sure thing, it's not a problem to remove it completely.
>>
>> Foolish question.  Is there any reason why this is a file instead
>> of being the obvious directory full of symlinks?
>>
>
> How would these symlinks look like? "../../pid"? There were a conversation
> about such things (https://lkml.org/lkml/2011/12/2/142) but I suppose we
> were agree on children with pids as consensus.

I couldn't find any agreement in this link. Suppose wrong url?


