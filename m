Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609Ab0GWLWX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 07:22:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:57429 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752558Ab0GWLWW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 07:22:22 -0400
Message-ID: <4C497B5C.7000704@kernel.org>
Date: Fri, 23 Jul 2010 13:22:04 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, dhowells@redhat.com, sfrench@samba.org,
        anton@samba.org, swhiteho@redhat.com, airlied@linux.ie,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCHSET wq#for-next] workqueue: replace slow-work with workqueue
References: <1279658102-20069-1-git-send-email-tj@kernel.org> <4C48B16B.2070605@kernel.org>
In-Reply-To: <4C48B16B.2070605@kernel.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 23 Jul 2010 11:22:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2010 11:00 PM, Tejun Heo wrote:
> On 07/20/2010 10:34 PM, Tejun Heo wrote:
>>  0001-fscache-convert-object-to-use-workqueue-instead-of-s.patch
>>  0002-fscache-convert-operation-to-use-workqueue-instead-o.patch
>>  0003-fscache-drop-references-to-slow-work.patch
>>  0004-cifs-use-workqueue-instead-of-slow-work.patch
> 
> 0001-0004 now pushed out to wq#for-next w/ acks added.

The rest of the series pushed out to wq#for-next.

Thanks.

-- 
tejun
