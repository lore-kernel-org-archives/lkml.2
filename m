Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306Ab2JMXRX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 19:17:23 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:33798 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754248Ab2JMXRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 19:17:22 -0400
MIME-Version: 1.0
In-Reply-To: <5077D353.3010708@jp.fujitsu.com>
References: <5077D353.3010708@jp.fujitsu.com>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Sat, 13 Oct 2012 19:17:01 -0400
Message-ID: <CAHGf_=qX=L+Kzjez=NpHxtkSQKKAwqTQ1sYi0cn-w_Ku4jdRdg@mail.gmail.com>
Subject: Re: [PATCH] mm: cleanup register_node()
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, rientjes@google.com,
        akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2012 at 4:22 AM, Yasuaki Ishimatsu
<isimatu.yasuaki@jp.fujitsu.com> wrote:
> register_node() is defined as extern in include/linux/node.h. But the function
> is only called from register_one_node() in driver/base/node.c.
>
> So the patch defines register_node() as static.
>
> CC: David Rientjes <rientjes@google.com>
> CC: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
