Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756904Ab1IIA2J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 20:28:09 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:33543 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756788Ab1IIA2I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 20:28:08 -0400
Message-ID: <4E695CBD.50208@parallels.com>
Date: Fri, 09 Sep 2011 04:24:29 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Cyrill Gorcunov <gorcunov@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>, Tejun Heo <tj@kernel.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        "containers@lists.osdl.org" <containers@lists.osdl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Nathan Lynch <ntl@pobox.com>,
        "kernel-hardening@lists.openwall.com" 
	<kernel-hardening@lists.openwall.com>,
        Oren Laadan <orenl@cs.columbia.edu>,
        Daniel Lezcano <dlezcano@fr.ibm.com>,
        Glauber Costa <glommer@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [patch 2/2] fs, proc: Introduce the /proc/<pid>/map_files/ directory
 v6
References: <20110906165144.GJ18425@mtj.dyndns.org>	<20110906172952.GA28055@albatros>	<20110906173341.GM18425@mtj.dyndns.org>	<20110907112301.GA12157@albatros>	<20110907215329.GB28162@sun>	<20110907151323.613e62e7.akpm@linux-foundation.org>	<20110907224234.GD28162@sun>	<20110907155332.beda7d3d.akpm@linux-foundation.org>	<20110908054826.GF28162@sun>	<20110908055025.GG28162@sun>	<20110908060405.GH28162@sun> <20110908165201.59e82c71.akpm@linux-foundation.org>
In-Reply-To: <20110908165201.59e82c71.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2011 03:52 AM, Andrew Morton wrote:
> On Thu, 8 Sep 2011 10:04:05 +0400
> Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> 
>> fs, proc: Introduce the /proc/<pid>/map_files/ directory v11
> 
> Ho hum, I've pretty much run out of excuses to avoid merging this.
> 
> except...
> 
> We don't really want to bloat fs/proc/base.o by 4k until all the other
> things which support c/r are mergeable and we know that the whole
> project is actually useful.  When will we be at this stage?

Well, I see no other stuff that will be required for us in the nearest
future (well, and in the not-so-near future as well) in the fs/proc/base.o
to checkpoint or restore a task.

Thanks,
Pavel
