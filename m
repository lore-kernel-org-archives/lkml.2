Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756345Ab1EGWle (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 18:41:34 -0400
Received: from smtp6-g21.free.fr ([212.27.42.6]:43667 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756151Ab1EGWlc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 18:41:32 -0400
Message-ID: <4DC5CA8D.3090604@free.fr>
Date: Sun, 08 May 2011 00:41:17 +0200
From: Daniel Lezcano <daniel.lezcano@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        jamal <hadi@cyberus.ca>, Linux Containers <containers@lists.osdl.org>,
        Renato Westphal <renatowestphal@gmail.com>
Subject: Re: [PATCH 3/7] ns proc: Add support for the network namespace.
References: <m1tyd7p7tq.fsf@fess.ebiederm.org> <1304735101-1824-1-git-send-email-ebiederm@xmission.com> <1304735101-1824-3-git-send-email-ebiederm@xmission.com>
In-Reply-To: <1304735101-1824-3-git-send-email-ebiederm@xmission.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2011 04:24 AM, Eric W. Biederman wrote:
> Implementing file descriptors for the network namespace
> is simple and straight forward.
>
> Signed-off-by: Eric W. Biederman<ebiederm@xmission.com>
> ---

Acked-by: Daniel Lezcano <daniel.lezcano@free.fr>
