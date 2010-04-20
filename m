Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256Ab0DTUrV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 16:47:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58704 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754666Ab0DTUrU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 16:47:20 -0400
Message-ID: <4BCE12CA.1070209@redhat.com>
Date: Tue, 20 Apr 2010 16:47:06 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Pete Zaitcev <zaitcev@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rmap: anon_vma_prepare() can leak anon_vma_chain
References: <20100415120940.GA31762@redhat.com> <4BCD0E78.9050904@redhat.com> <20100420192420.GA20840@redhat.com>
In-Reply-To: <20100420192420.GA20840@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/20/2010 03:24 PM, Oleg Nesterov wrote:
> If find_mergeable_anon_vma() succeeds but another thread installs
> ->anon_vma before we take ptl, then allocated == NULL but avc should
> be freed. Change the code to check avc != NULL to detect this case.

Good catch!

> Signed-off-by: Oleg Nesterov<oleg@redhat.com>

Reviewed-by: Rik van Riel <riel@redhat.com>
