Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437Ab2LMIvp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 03:51:45 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44829 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753166Ab2LMIvo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 03:51:44 -0500
Message-ID: <50C99720.20402@suse.cz>
Date: Thu, 13 Dec 2012 09:51:44 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Adam Lee <adam8157@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 4/5] ktest: Fix breakage from change of oldnoconfig to
 olddefconfig
References: <20121212221437.245229327@goodmis.org> <20121212221544.350555692@goodmis.org> <20121213030602.GA10129@adam-station.nay.redhat.com>
In-Reply-To: <20121213030602.GA10129@adam-station.nay.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13.12.2012 04:06, Adam Lee wrote:
> On Wed, Dec 12, 2012 at 05:14:41PM -0500, Steven Rostedt wrote:
>> From: Steven Rostedt <srostedt@redhat.com>
>>
>> Commit fb16d891 "kconfig: replace 'oldnoconfig' with 'olddefconfig', and
>> keep the old name", changed ktest's default config update from
>> oldnoconfig to olddefconfig without adding oldnoconfig as a backup.
>> The make oldnoconfig works much better than its backup of:
>>    yes '' | make oldconfig
>>
>> But due to this change, and the fact that ktest is used to build lots of
>> older kernels (and for bisects), it forgoes the oldnoconfig completely.
>>
>> Cc: Adam Lee <adam8157@gmail.com>
>> Cc: Michal Marek <mmarek@suse.cz>
>> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> This makes sense, we should provide a backup for older kernels. Sorry
> for not noticing the breakage.
> 
> Acked-by: Adam Lee <adam8157@gmail.com>

Acked-by: Michal Marek <mmarek@suse.cz>

Michal

