Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760016Ab2FUTHo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 15:07:44 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:58335 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759961Ab2FUTHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 15:07:42 -0400
Message-ID: <4FE36D32.3030408@linux.vnet.ibm.com>
Date: Thu, 21 Jun 2012 13:51:30 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 01/10] zcache: fix preemptable memory allocation in atomic
 context
References: <4FE0392E.3090300@linux.vnet.ibm.com>
In-Reply-To: <4FE0392E.3090300@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12062119-1780-0000-0000-000006AE9788
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000282; HX=3.00000190; KW=3.00000007;
 PH=3.00000001; SC=3.00000003; SDB=6.00150050; UDB=6.00034099; UTC=2012-06-21
 19:07:39
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just noticed you sent this patchset to Andrew, but the
staging tree is maintained by Greg.  You're going to want to
send these patches to him.

Greg Kroah-Hartman <gregkh@linuxfoundation.org>

--
Seth

