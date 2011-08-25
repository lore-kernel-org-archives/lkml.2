Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991Ab1HYGnm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 02:43:42 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:44122 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751336Ab1HYGnl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 02:43:41 -0400
Message-ID: <4E55EEE4.4050902@parallels.com>
Date: Thu, 25 Aug 2011 10:42:44 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Zan Lynx <zlynx@acm.org>, Cyrill Gorcunov <gorcunov@gmail.com>,
        Nathan Lynch <ntl@pobox.com>, Oren Laadan <orenl@cs.columbia.edu>,
        Daniel Lezcano <dlezcano@fr.ibm.com>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Glauber Costa <glommer@parallels.com>,
        "containers@lists.osdl.org" <containers@lists.osdl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        LINUXFS-ML <linux-fsdevel@vger.kernel.org>,
        James Bottomley <jbottomley@parallels.com>
Subject: Re: [RFC] fs, proc: Introduce the /proc/<pid>/map_files/ directory
 v2
References: <20110824085329.GL29452@sun> <4E551331.1010709@acm.org>	<4E551693.5030400@parallels.com> <m2wre2d83p.fsf@firstfloor.org>
In-Reply-To: <m2wre2d83p.fsf@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24/2011 09:36 PM, Andi Kleen wrote:
> Pavel Emelyanov <xemul@parallels.com> writes:
>>
>> No and this is the trick - when you readlink it - it give you trash, but
>> when you open one - you get exactly the same file as the map points to.
> 
> Isn't that a minor security hole?
> 
> For example if I pass a file descriptor into a chroot process for
> reading, and with this interface you can open it for writing too.
> I could see this causing problems.

How does it differ from the /proc/pid/fd links?

> -Andi
> 

