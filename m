Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758249Ab1KRRQM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 12:16:12 -0500
Received: from mx2.netapp.com ([216.240.18.37]:26022 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758070Ab1KRRQK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 12:16:10 -0500
X-IronPort-AV: E=Sophos;i="4.69,534,1315206000"; 
   d="scan'208";a="600044822"
Date: Fri, 18 Nov 2011 19:16:05 +0200
Subject: Re: [PATCH] Don't hang user processes if Kerberos ticket for nfs4 mount expires
Message-ID: <00c101cca615$c2e08db6$78be630a@hq.netapp.com>
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: "Jim Rees" <rees@umich.edu>, "John Hughes" <john@Calva.COM>
thread-topic: [PATCH] Don't hang user processes if Kerberos ticket for nfs4 mount expires
thread-index: AcymFcLgDUShbZzpTQ+vVkh41ZOjDA==
X-MimeOLE: Produced By Microsoft Exchange V6.5
Cc: "Jeff Layton" <jlayton@redhat.com>, <linux-nfs@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
X-OriginalArrivalTime: 18 Nov 2011 17:16:09.0751 (UTC) FILETIME=[C3DDAA70:01CCA615]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So what are they supposed to do without tickets? Crash?

Jim Rees <rees@umich.edu> wrote:

I'm not arguing that the client machine should hang when tickets expire.
I'm arguing that user processes should not hang when tickets expire.  Sorry
if that wasn't clear.
