Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762075Ab2FHQbW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 12:31:22 -0400
Received: from mx3-phx2.redhat.com ([209.132.183.24]:35777 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931Ab2FHQbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 12:31:21 -0400
Date: Fri, 08 Jun 2012 12:31:16 -0400 (EDT)
From: Zhouping Liu <zliu@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>
Cc: Hillf Danton <dhillf@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: AutoNUMA15
Message-ID: <e5f59057-fbed-4bbf-a706-ff75d459f130@zmail13.collab.prod.int.phx2.redhat.com>
In-Reply-To: <1339162376.2507.14.camel@laptop>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.66.113.238]
X-Mailer: Zimbra 7.1.2_GA_3268 (ZimbraWebClient - FF3.0 (Linux)/7.1.2_GA_3268)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> 
> Please try tip/master, if it still fails, please report in a new
> thread
> with appropriate subject.

I tested tip/master(commit: b2f5ce55c4e683), it's OK without the above panic,
also tested mainline(commit: 48d212a2eecaca2), the panic still exist.

and I will open a new subject to trace the issue.

-- 
Thanks,
Zhouping
