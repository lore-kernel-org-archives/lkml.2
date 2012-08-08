Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932623Ab2HHJ2l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 05:28:41 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36689 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932391Ab2HHJ2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 05:28:40 -0400
Message-ID: <50223141.3030103@gmail.com>
Date: Wed, 08 Aug 2012 17:28:33 +0800
From: Cong Wang <xiyou.wangcong@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Jenny TC <jenny.tc@intel.com>
CC: paul.gortmaker@windriver.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel_notifier: register conditional raw notifier
References: <1344423428-23240-1-git-send-email-jenny.tc@intel.com>
In-Reply-To: <1344423428-23240-1-git-send-email-jenny.tc@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2012 06:57 PM, Jenny TC wrote:
> Introduce a new API raw_notifier_chain_cond_register to
> add a notifier to a raw notifier chain, only if notifier
> not already present in the chain.

Forgot its declaration?

