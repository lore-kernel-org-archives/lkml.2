Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181Ab1LKS65 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 13:58:57 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:59815 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930Ab1LKS6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 13:58:54 -0500
Message-ID: <4EE4FD69.1080609@gmail.com>
Date: Sun, 11 Dec 2011 13:58:49 -0500
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Glauber Costa <glommer@parallels.com>
CC: linux-kernel@vger.kernel.org, jbottomley@parallels.com,
        cgroups@vger.kernel.org, bsingharora@gmail.com, devel@openvz.org,
        kamezawa.hiroyu@jp.fujitsu.com, tj@kernel.org
Subject: Re: [PATCH 2/3] make clone_children a flag
References: <1323614738-7405-1-git-send-email-glommer@parallels.com> <1323614738-7405-4-git-send-email-glommer@parallels.com>
In-Reply-To: <1323614738-7405-4-git-send-email-glommer@parallels.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(12/11/11 9:45 AM), Glauber Costa wrote:
> There is no reason to have a flags field, and then a separate
> bool field just to indicate if the clone_children flag is set.
> Make it a flag
> 
> Signed-off-by: Glauber Costa<glommer@parallels.com>
> ---
>   kernel/cgroup.c |    6 +++---
>   1 files changed, 3 insertions(+), 3 deletions(-)

Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

