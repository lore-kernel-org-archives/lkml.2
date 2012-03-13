Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758234Ab2CMHVO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 03:21:14 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:49271 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753915Ab2CMHVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 03:21:13 -0400
Message-ID: <4F5EF563.5000700@openvz.org>
Date: Tue, 13 Mar 2012 11:21:07 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120217 Firefox/10.0.2 Iceape/2.7.2
MIME-Version: 1.0
To: minchan@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        riel@redhat.com, kosaki.motohiro@jp.fujitsu.com,
        Zheng Liu <wenqing.lz@taobao.com>
Subject: Re: Fwd: Control page reclaim granularity
References: <20120313024818.GA7125@barrios> <1331620214-4893-1-git-send-email-wenqing.lz@taobao.com> <20120313064832.GA4968@gmail.com>
In-Reply-To: <20120313064832.GA4968@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zheng Liu wrote:
> Sorry, please forgive me.  This patch has a defect.  When one page is
> scaned and flag is clear, all other's flags also are clear too.

Yeah, funny patch =)
