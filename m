Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756621Ab2CVJGD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 05:06:03 -0400
Received: from mx2.parallels.com ([64.131.90.16]:50350 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756535Ab2CVJF6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 05:05:58 -0400
Message-ID: <4F6AEB0E.7070606@parallels.com>
Date: Thu, 22 Mar 2012 13:04:14 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <lizf@cn.fujitsu.com>, <containers@lists.linux-foundation.org>,
        <cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <fweisbec@gmail.com>, <rni@google.com>, <ctalbott@google.com>
Subject: Re: [PATCHSET] cgroup: cftype based file interface, take #2
References: <1332368265-21586-1-git-send-email-tj@kernel.org>
In-Reply-To: <1332368265-21586-1-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2012 02:17 AM, Tejun Heo wrote:
> Can you please send a patch to move init to
> ->create()?

Yes.

