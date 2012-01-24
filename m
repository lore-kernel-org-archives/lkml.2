Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290Ab2AXItb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 03:49:31 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:54318 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754577Ab2AXIta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 03:49:30 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [patch 1/4] fs, proc: Introduce /proc/<pid>/task/<tid>/children entry v8
References: <20120123142036.025893883@openvz.org>
	<20120123142436.181674896@openvz.org>
	<20120124110730.a3536647.kamezawa.hiroyu@jp.fujitsu.com>
	<20120124065338.GB29735@moon>
	<20120124160709.e05c51b5.kamezawa.hiroyu@jp.fujitsu.com>
	<20120124072122.GD29735@moon>
Date: Tue, 24 Jan 2012 00:52:03 -0800
In-Reply-To: <20120124072122.GD29735@moon> (Cyrill Gorcunov's message of "Tue,
	24 Jan 2012 11:21:22 +0400")
Message-ID: <m1boptmqj0.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19+6ktCgvvxDbQ4v00qxHq21q0xgVVTVRY=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov <gorcunov@gmail.com> writes:

> On Tue, Jan 24, 2012 at 04:07:09PM +0900, KAMEZAWA Hiroyuki wrote:
>> > 
>> > Hmm. But userspace app will get eof, so frankly I don't see
>> > a problem here. Or maybe I miss something?
>> > 
>> 
>> Userspace need to take care of whether there may be"\n" or not even
>> if read() returns EOF.
>> As an interface, it's BUG to say "\n" will be there if you're lucky!"
>> (*) I know script language can handle this but we shouldn't assume that.
>> 
>> How about just remove "\n" at EOF  ? I think it's unnecessary.
>> 
>
> Sure thing, it's not a problem to remove it completely.

Foolish question.  Is there any reason why this is a file instead
of being the obvious directory full of symlinks?

Eric
