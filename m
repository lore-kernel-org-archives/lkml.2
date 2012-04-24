Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757522Ab2DXULM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 16:11:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64176 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756791Ab2DXULL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 16:11:11 -0400
Message-ID: <4F9708D9.5060500@redhat.com>
Date: Tue, 24 Apr 2012 16:11:05 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: lwoodman@redhat.com
CC: Christoph Lameter <cl@linux.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>, linux-mm@kvack.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Motohiro Kosaki <mkosaki@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -mm V2] do_migrate_pages() calls migrate_to_node() even
 if task is already on a correct node
References: <4F96CDE1.5000909@redhat.com> <4F96D27A.2050005@gmail.com> <4F96DFE0.6040306@redhat.com> <alpine.DEB.2.00.1204241317170.26005@router.home> <4F97082B.9040903@redhat.com>
In-Reply-To: <4F97082B.9040903@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2012 04:08 PM, Larry Woodman wrote:
> On 04/24/2012 02:17 PM, Christoph Lameter wrote:
>> On Tue, 24 Apr 2012, Larry Woodman wrote:
>>
>>> How does this look:
>>
>> Could you please send the patches inline? Its difficult to quote the
>> attachment.
>>
>
> Sorry all of these email clients are different.

Neither the comment or the changelog explains why you want
to make this change.

-- 
All rights reversed
