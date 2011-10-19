Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098Ab1JSMoj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 08:44:39 -0400
Received: from 87-104-106-3-dynamic-customer.profibernet.dk ([87.104.106.3]:58758
	"EHLO kernel.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047Ab1JSMoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 08:44:38 -0400
Message-ID: <4E9EC636.8000806@kernel.dk>
Date: Wed, 19 Oct 2011 14:44:38 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org, vgoyal@redhat.com, ctalbott@google.com,
        rni@google.com
Subject: Re: [PATCHSET block/for-next] fix request_queue life-cycle management
References: <1318998384-22525-1-git-send-email-tj@kernel.org>
In-Reply-To: <1318998384-22525-1-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-10-19 06:26, Tejun Heo wrote:
> This patchset is on top of the block/for-next cef1e172c7 "Merge branch
> 'for-3.2/mtip32xx' into for-next" and available in the following git
> branch.
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git block-ref

I've applied this, thanks a lot for taking the time to sort these rules.
It's been broken for a long time.

-- 
Jens Axboe

