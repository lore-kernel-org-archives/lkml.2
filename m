Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752251Ab1LKS7a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 13:59:30 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:47970 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159Ab1LKS73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 13:59:29 -0500
Message-ID: <4EE4FD8D.4020704@gmail.com>
Date: Sun, 11 Dec 2011 13:59:25 -0500
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Glauber Costa <glommer@parallels.com>
CC: linux-kernel@vger.kernel.org, jbottomley@parallels.com,
        cgroups@vger.kernel.org, bsingharora@gmail.com, devel@openvz.org,
        kamezawa.hiroyu@jp.fujitsu.com, tj@kernel.org
Subject: Re: [PATCH 3/3] make 'none' field a flag
References: <1323614738-7405-1-git-send-email-glommer@parallels.com> <1323614738-7405-5-git-send-email-glommer@parallels.com>
In-Reply-To: <1323614738-7405-5-git-send-email-glommer@parallels.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(12/11/11 9:45 AM), Glauber Costa wrote:
> There is no reason to have a flags field, and then a separate
> bool field just to indicate if 'none' subsystem were explicitly
> requested.
> 
> Make it a flag
> 
> Signed-off-by: Glauber Costa<glommer@parallels.com>

Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



