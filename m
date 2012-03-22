Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759007Ab2CVStc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 14:49:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1553 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758933Ab2CVSt0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 14:49:26 -0400
Message-ID: <4F6B7431.8080701@redhat.com>
Date: Thu, 22 Mar 2012 14:49:21 -0400
From: Larry Woodman <lwoodman@redhat.com>
Reply-To: lwoodman@redhat.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Red Hat/3.1.7-3.el6_0 Thunderbird/3.1.7
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
CC: Christoph Lameter <cl@linux.com>, linux-mm@kvack.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Motohiro Kosaki <mkosaki@redhat.com>
Subject: Re: [PATCH -mm] do_migrate_pages() calls migrate_to_node() even if
 task is already on a correct node
References: <4F6B6BFF.1020701@redhat.com> <4F6B7358.60800@gmail.com>
In-Reply-To: <4F6B7358.60800@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2012 02:45 PM, KOSAKI Motohiro wrote:
> CC to Christoph.
>
>
Sorry Christoph I meant to cc you on the original message!

Larry

> Wait.
>
> This may be non-optimal for cpusets, but maybe optimal migrate_pages, 
> especially
> the usecase is HPC. I guess this is intended behavior. I think we need 
> to hear
> Christoph's intention.
>
> But, I'm not against this if he has no objection.
>
>

