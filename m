Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282Ab0KPQ5S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 11:57:18 -0500
Received: from mail1.slb.deg.dub.stisp.net ([84.203.253.98]:14793 "HELO
	mail1.slb.deg.dub.stisp.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754848Ab0KPQ5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 11:57:17 -0500
Message-ID: <4CE2B7C7.4080406@draigBrady.com>
Date: Tue, 16 Nov 2010 16:56:39 +0000
From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: Josef Bacik <josef@redhat.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] Ext4: fail if we try to use hole punch
References: <1289840723-3056-1-git-send-email-josef@redhat.com> <1289840723-3056-5-git-send-email-josef@redhat.com> <4CE2AF5B.7020500@draigBrady.com> <20101116163320.GB2524@localhost.localdomain>
In-Reply-To: <20101116163320.GB2524@localhost.localdomain>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/11/10 16:33, Josef Bacik wrote:
> On Tue, Nov 16, 2010 at 04:20:43PM +0000, Pádraig Brady wrote:
>>
>> So for older versions of ext4 or other filesystems, how do we know
>> that fallocate(...,FALLOC_FL_PUNCH_HOLE) is not supported.
>> I.E. how do we detect at runtime that the call succeeded
>> and didn't just do a normal fallocate()?
>>
> 
> Older kernels won't accept FALLOC_FL_PUNCH_HOLE, so you'll get an error.
> Thanks,

Oops right.
Older kernels filter FALLOC_FL_PUNCH_HOLE at a higher level in fs/open.c
Whereas newer kernels will do it per file system.

thanks,
Pádraig.
