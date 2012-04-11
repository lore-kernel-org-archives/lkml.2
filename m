Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760407Ab2DKOmE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 10:42:04 -0400
Received: from relay.parallels.com ([195.214.232.42]:54128 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756726Ab2DKOmC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 10:42:02 -0400
Message-ID: <4F859823.4020902@parallels.com>
Date: Wed, 11 Apr 2012 18:41:39 +0400
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Lightning/1.0b2 Thunderbird/3.1.20
MIME-Version: 1.0
To: "J. Bruce Fields" <bfields@fieldses.org>
CC: "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@openvz.org" <devel@openvz.org>
Subject: Re: [PATCH 4/8] nfsd: use exp_put() for svc_export_cache put
References: <20120328150152.2646.33607.stgit@localhost6.localdomain6> <20120328150921.2646.46229.stgit@localhost6.localdomain6> <20120411141614.GB27751@fieldses.org>
In-Reply-To: <20120411141614.GB27751@fieldses.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

11.04.2012 18:16, J. Bruce Fields пишет:
> On Wed, Mar 28, 2012 at 07:09:22PM +0400, Stanislav Kinsbursky wrote:
>> This patch replaces cache_put() call for svc_export_cache by exp_put() call.
>
> Patch looks fine.  Minor peeve: the changelog doesn't tell me anything I
> couldn't figure out immediately from reading the patch.  Tell me *why*
> we're doing this ("Removing another hard-coded svc_export_cache will
> simplify adding per-export caches later"), or if it's really totally
> obvious I'd rather have an empty changelog than a useless one....
>

Ok, will do so for further patches.

-- 
Best regards,
Stanislav Kinsbursky
