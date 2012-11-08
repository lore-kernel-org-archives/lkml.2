Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062Ab2KHOb1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 09:31:27 -0500
Received: from oproxy9.bluehost.com ([69.89.24.6]:38709 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755695Ab2KHOb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 09:31:26 -0500
Message-ID: <509BC238.6000306@tao.ma>
Date: Thu, 08 Nov 2012 22:31:20 +0800
From: Tao Ma <tm@tao.ma>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH] cgroup: set 'start' with the right value in cgroup_path.
References: <1352381798-2357-1-git-send-email-tm@tao.ma> <20121108142452.GB12973@htj.dyndns.org>
In-Reply-To: <20121108142452.GB12973@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 122.224.222.226 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/2012 10:24 PM, Tejun Heo wrote:
> Hello,
> 
> On Thu, Nov 08, 2012 at 09:36:38PM +0800, Tao Ma wrote:
>> From: Tao Ma <boyu.mt@taobao.com>
>>
>> 'start' is set to buf + buflen and do the '--' immediately.
>> Just set it to 'buf + buflen - 1' directly.
>>
>> Cc: Tejun Heo <tj@kernel.org>
>> Cc: Li Zefan <lizefan@huawei.com>
> 
> You're missing S-O-B.  I added it while applying.  Please ack if you
> agree.
oops, sorry, please add
Signed-off-by: Tao Ma <boyu.mt@taobao.com>

Thanks
Tao
> 
> Heh, I'm not sure how much of an improvement this is but there's
> obviously nothing wrong with it either.  Applying to cgroup/for-3.8.
> 
> Thanks.
> 

