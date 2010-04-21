Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755684Ab0DUPYm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 11:24:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20317 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755634Ab0DUPYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 11:24:39 -0400
Message-ID: <4BCF18A8.8080809@redhat.com>
Date: Wed, 21 Apr 2010 11:24:24 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Dan Carpenter <error27@gmail.com>, Izik Eidus <ieidus@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, kernel-janitors@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] ksm: check for ERR_PTR from follow_page()
References: <20100421102759.GA29647@bicker>
In-Reply-To: <20100421102759.GA29647@bicker>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/2010 06:27 AM, Dan Carpenter wrote:
> The follow_page() function can potentially return -EFAULT so I added
> checks for this.
>
> Also I silenced an uninitialized variable warning on my version of gcc
> (version 4.3.2).
>
> Signed-off-by: Dan Carpenter<error27@gmail.com>

Acked-by: Rik van Riel <riel@redhat.com>
