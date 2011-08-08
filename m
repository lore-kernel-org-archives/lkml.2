Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566Ab1HHOrF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 10:47:05 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:10476 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392Ab1HHOrD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 10:47:03 -0400
Message-ID: <4E3FF6DF.2000303@parallels.com>
Date: Mon, 08 Aug 2011 18:46:55 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Cyrill Gorcunov <gorcunov@openvz.org>, Nathan Lynch <ntl@pobox.com>,
        Oren Laadan <orenl@cs.columbia.edu>,
        Daniel Lezcano <dlezcano@fr.ibm.com>, Serge Hallyn <serue@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Glauber Costa <glommer@parallels.com>,
        "containers@lists.osdl.org" <containers@lists.osdl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: Re: [patch 3/4] proc: Introduce the Children: line in /proc/<pid>/status
References: <20110807212031.GG2080@sun> <20110808144035.GB22863@htj.dyndns.org>
In-Reply-To: <20110808144035.GB22863@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2011 06:40 PM, Tejun Heo wrote:
> On Mon, Aug 08, 2011 at 01:20:31AM +0400, Cyrill Gorcunov wrote:
>> From: Pavel Emelyanov <xemul@parallels.com>
>>
>> Although we can get the pids of some task's issue, this is just 
>> more convenient to have them this way.
>>
>> Signed-off-by: Pavel Emelyanov <xemul@parallels.com>
>> Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
>> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> 
> I'm not necessarily against this one but don't really see much point
> either.  Can we delay this for now?

Sure we can. As I stated previously this one just makes our live easier, but
we can live without one.

> Thanks.
> 

