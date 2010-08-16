Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825Ab0HPH64 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 03:58:56 -0400
Received: from hera.kernel.org ([140.211.167.34]:58223 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752607Ab0HPH6z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 03:58:55 -0400
Message-ID: <4C68EF09.2010509@kernel.org>
Date: Mon, 16 Aug 2010 09:55:53 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Xiaotian Feng <dfeng@redhat.com>
CC: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH] workqueue: free rescuer on destroy_workqueue
References: <1281694939-4163-1-git-send-email-dfeng@redhat.com>
In-Reply-To: <1281694939-4163-1-git-send-email-dfeng@redhat.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 16 Aug 2010 07:58:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2010 12:22 PM, Xiaotian Feng wrote:
> wq->rescuer is not freed when wq is destroyed, leads a memory leak
> then. This patch also remove a redundant line.
> 
> Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Oleg Nesterov <oleg@redhat.com>

Applied to wq#for-linus.  Thanks.

-- 
tejun
