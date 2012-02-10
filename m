Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759695Ab2BJRte (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 12:49:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23269 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759562Ab2BJRtd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 12:49:33 -0500
Message-ID: <4F3558A7.8030706@redhat.com>
Date: Fri, 10 Feb 2012 17:49:27 +0000
From: Pedro Alves <palves@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Denys Vlasenko <vda.linux@googlemail.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] ptrace: remove PTRACE_SEIZE_DEVEL bit
References: <1328884991-23889-1-git-send-email-vda.linux@googlemail.com> <1328884991-23889-2-git-send-email-vda.linux@googlemail.com> <1328884991-23889-3-git-send-email-vda.linux@googlemail.com> <1328884991-23889-4-git-send-email-vda.linux@googlemail.com> <1328884991-23889-5-git-send-email-vda.linux@googlemail.com> <1328884991-23889-6-git-send-email-vda.linux@googlemail.com> <20120210172427.GE8908@redhat.com> <4F3557D9.7000408@redhat.com> <20120210174212.GA10011@redhat.com>
In-Reply-To: <20120210174212.GA10011@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10/2012 05:42 PM, Oleg Nesterov wrote:
> On 02/10, Pedro Alves wrote:
>>
>> Do new auto-attached clones still generate SIGSTOP, or has than been fixed already?
> 
> Hopefully fixed by d184d6eb
> "ptrace: dont send SIGSTOP on auto-attach if PT_SEIZED"

Awesome, thanks.

-- 
Pedro Alves
