Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044Ab1LKOto (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 09:49:44 -0500
Received: from mx2.parallels.com ([64.131.90.16]:33670 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751259Ab1LKOtd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 09:49:33 -0500
Message-ID: <4EE4C2D2.9090402@parallels.com>
Date: Sun, 11 Dec 2011 15:48:50 +0100
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Glauber Costa <glommer@parallels.com>
CC: <linux-kernel@vger.kernel.org>, <jbottomley@parallels.com>,
        <cgroups@vger.kernel.org>, <bsingharora@gmail.com>, <devel@openvz.org>,
        <kamezawa.hiroyu@jp.fujitsu.com>, <tj@kernel.org>
Subject: Re: [PATCH] make clone_children a flag
References: <1323614738-7405-1-git-send-email-glommer@parallels.com> <1323614738-7405-2-git-send-email-glommer@parallels.com>
In-Reply-To: <1323614738-7405-2-git-send-email-glommer@parallels.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [80.187.216.97]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2011 03:45 PM, Glauber Costa wrote:
> There is no reason to have a flags field, and then a separate
> bool field just to indicate if the clone_children flag is set.
> Make it a flag
>
> Signed-off-by: Glauber Costa<glommer@parallels.com>

This one is repeated, I don't know how it went through. Sorry.
