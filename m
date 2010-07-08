Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828Ab0GHE3g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 00:29:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57793 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750771Ab0GHE3f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 00:29:35 -0400
Message-ID: <4C355417.3020503@redhat.com>
Date: Thu, 08 Jul 2010 00:29:11 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       avi@redhat.com, mingo@elte.hu, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, hpa@zytor.com, cl@linux-foundation.org,
       mtosatti@redhat.com
Subject: Re: [PATCH v4 12/12] Send async PF when guest is not in userspace
 too.
References: <1278433500-29884-1-git-send-email-gleb@redhat.com> <1278433500-29884-13-git-send-email-gleb@redhat.com>
In-Reply-To: <1278433500-29884-13-git-send-email-gleb@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/06/2010 12:25 PM, Gleb Natapov wrote:
> Signed-off-by: Gleb Natapov<gleb@redhat.com>

This patch needs a commit message on the next submission.
Other than that:

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
