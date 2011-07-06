Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723Ab1GFQfu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 12:35:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28625 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754662Ab1GFQfs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 12:35:48 -0400
Message-ID: <4E148ECE.3040804@redhat.com>
Date: Wed, 06 Jul 2011 12:35:26 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Isaku Yamahata <yamahata@valinux.co.jp>,
        Eddie Dong <eddie.dong@intel.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>,
        Anthony Liguori <aliguori@us.ibm.com>,
        Eric B Munson <emunson@mgebm.net>
Subject: Re: [PATCH v5 6/9] add jump labels for ia64 paravirt
References: <1309793548-16714-1-git-send-email-glommer@redhat.com> <1309793548-16714-7-git-send-email-glommer@redhat.com>
In-Reply-To: <1309793548-16714-7-git-send-email-glommer@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/2011 11:32 AM, Glauber Costa wrote:
> Since in a later patch I intend to call jump labels inside
> CONFIG_PARAVIRT, IA64 would fail to compile if they are not
> provided. This patch provides those jump labels for the IA64
> architecture.
>
> Signed-off-by: Glauber Costa<glommer@redhat.com>
> CC: Isaku Yamahata<yamahata@valinux.co.jp>
> CC: Eddie Dong<eddie.dong@intel.com>
> CC: Rik van Riel<riel@redhat.com>
> CC: Jeremy Fitzhardinge<jeremy.fitzhardinge@citrix.com>
> CC: Peter Zijlstra<peterz@infradead.org>
> CC: Avi Kivity<avi@redhat.com>
> CC: Anthony Liguori<aliguori@us.ibm.com>
> CC: Eric B Munson<emunson@mgebm.net>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
