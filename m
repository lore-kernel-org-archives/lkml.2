Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267Ab2H1RTk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 13:19:40 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52083 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676Ab2H1RTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 13:19:38 -0400
Message-ID: <503CFDA2.6040407@gmail.com>
Date: Tue, 28 Aug 2012 11:19:30 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Andrew Jones <drjones@redhat.com>
CC: Dong Hao <haodong@linux.vnet.ibm.com>, avi@redhat.com, acme@infradead.org,
        mtosatti@redhat.com, mingo@elte.hu, xiaoguangrong@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v7 3/3] KVM: perf: kvm events analysis tool
References: <1346061106-5364-1-git-send-email-haodong@linux.vnet.ibm.com> <1346061106-5364-4-git-send-email-haodong@linux.vnet.ibm.com> <20120827155331.GA18224@turtle.usersys.redhat.com> <503BCBCC.8060509@gmail.com> <20120828063539.GA2280@turtle.usersys.redhat.com>
In-Reply-To: <20120828063539.GA2280@turtle.usersys.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/28/12 12:35 AM, Andrew Jones wrote:
> This is the second user. As I said, move the stats code from
> builtin-stat.c. Or are you suggesting to duplicate the code once,
> and then refactor the second (really the third) time it's needed?

gah, I misunderstood your comment. I see your point now.

Davi

