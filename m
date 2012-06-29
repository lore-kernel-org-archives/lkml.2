Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288Ab2F2Ks5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 06:48:57 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:28831 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754383Ab2F2Ksz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 06:48:55 -0400
Message-ID: <4FED87F2.7000309@oracle.com>
Date: Fri, 29 Jun 2012 18:48:18 +0800
From: Junxiao Bi <junxiao.bi@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: ocfs2-devel@oss.oracle.com, linux-aio@kvack.org, mfasheh@suse.com,
        linux-kernel@vger.kernel.org, joe.jin@oracle.com,
        stable@vger.kernel.org
Subject: Re: [PATCH v4 1/2] aio: make kiocb->private NUll in init_sync_kiocb()
References: <1340788195-20623-1-git-send-email-junxiao.bi@oracle.com> <1340788195-20623-2-git-send-email-junxiao.bi@oracle.com> <20120628153956.9b7405d9.akpm@linux-foundation.org> <20120629092255.GB12521@dhcp-172-17-9-228.mtv.corp.google.com> <4FED80A7.7040507@oracle.com> <20120629032900.15e36adf.akpm@linux-foundation.org>
In-Reply-To: <20120629032900.15e36adf.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2012 06:29 PM, Andrew Morton wrote:
> On Fri, 29 Jun 2012 18:17:11 +0800 Junxiao Bi <junxiao.bi@oracle.com> wrote:
>
>> Andrew had merged this patch to his tree. Do you like the second patch "
>> ocfs2: clear unaligned io flag when dio fails"?
> Please go ahead with your patchset for now.  I'll feed the cleanup in
> later on.
Ok, thank you.

