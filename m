Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112Ab1K2DZT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 22:25:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17632 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752499Ab1K2DZS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 22:25:18 -0500
Message-ID: <4ED4508D.3020502@redhat.com>
Date: Tue, 29 Nov 2011 11:25:01 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Sergei Shtylyov <sshtylyov@mvista.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Jeff Garzik <jgarzik@pobox.com>,
        linux-ide@vger.kernel.org
Subject: Re: [PATCH 10/62] ata: remove the second argument of k[un]map_atomic()
References: <1322371662-26166-1-git-send-email-amwang@redhat.com>	 <1322371662-26166-11-git-send-email-amwang@redhat.com>	 <4ED35BFE.6080900@mvista.com> <4ED373C3.4050903@redhat.com>	 <4ED37541.4040701@redhat.com> <1322506812.5071.37.camel@dabdike.int.hansenpartnership.com>
In-Reply-To: <1322506812.5071.37.camel@dabdike.int.hansenpartnership.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年11月29日 03:00, James Bottomley 写道:
>
> I'd vote for as a whole as well, but if there's some legitimate reason
> why not, then take them through Jiri's trivial tree; it's pretty trivial
> anyway and at least going that way would keep them bisectable.
>

Ok, I just made a branch which keeps these patches as a single one,

git://github.com/congwang/linux.git #kmap_atomic-single

As the single patch is 233K, so I don't send it to mailing list.

Thanks.
