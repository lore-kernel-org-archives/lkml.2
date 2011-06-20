Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184Ab1FTOpX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 10:45:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55525 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754889Ab1FTOpU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 10:45:20 -0400
Message-ID: <4DFF5CCA.6070206@redhat.com>
Date: Mon, 20 Jun 2011 10:44:26 -0400
From: Eric Paris <eparis@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Vasiliy Kulikov <segoon@openwall.com>
CC: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        apparmor@lists.ubuntu.com,
        "selinux@tycho.nsa.gov Stephen Smalley" <sds@tycho.nsa.gov>,
        James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>,
        John Johansen <john.johansen@canonical.com>,
        kernel-hardening@lists.openwall.com, serge@hallyn.com
Subject: Re: [RFC v2] security: intoduce ptrace_task_may_access_current
References: <20110617171152.GA1389@albatros> <4DFF5795.9080609@redhat.com> <20110620144328.GA11933@albatros>
In-Reply-To: <20110620144328.GA11933@albatros>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2011 10:43 AM, Vasiliy Kulikov wrote:
> On Mon, Jun 20, 2011 at 10:22 -0400, Eric Paris wrote:
>> serge even if you disagree with all of that, you are definitely
>> going to need to review the capability changes added here.
>> Personally I'd like to see all of the capability changes done as a
>> separate patch from the ptrace changes.
> I'm afraid the patch series will not be bisectable (capabilities and
> ptrace code are very interconnected), but I'll try.

Just add the new functions, describe them, document them, but don't use 
them.  Then use them in the second patch.

-Eric
