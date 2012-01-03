Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184Ab2ACQwE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 11:52:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35737 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754039Ab2ACQwC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 11:52:02 -0500
Message-ID: <4F033227.3020404@redhat.com>
Date: Tue, 03 Jan 2012 17:51:51 +0100
From: Denys Vlasenko <dvlasenk@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Denys Vlasenko <vda.linux@googlemail.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org,
        =?UTF-8?B?xYF1a2FzeiBNaWNoYWxpaw==?= <lmi@ift.uni.wroc.pl>,
        "Dmitry V. Levin" <ldv@altlinux.org>
Subject: Re: ptrace fixes for 3.2
References: <201112281955.55200.vda.linux@googlemail.com> <20111229113245.GA18062@redhat.com> <20111229120506.GA23653@redhat.com> <20120103142941.GA25488@redhat.com> <20120103154404.GA28930@redhat.com>
In-Reply-To: <20120103154404.GA28930@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03/2012 04:44 PM, Oleg Nesterov wrote:
> On 01/03, Oleg Nesterov wrote:
>>
>> I am going to send the hack^Wpatch below to Linus as a temporary
>> workaround for 3.2.
>
> The same patch with the changelog.
>
> Denys, Tejun, any chance you can review it before I send it to Linus ?

Testing it on top of Fedora 16's kernel-3.1.6-1.fc16:

Confirmed that before patch both tests fail (in about a minute of run time
at worst), and with patch they do not fail.

-- 
vda
