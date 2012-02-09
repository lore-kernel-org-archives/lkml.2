Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756955Ab2BIO6A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 09:58:00 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:57222 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752265Ab2BIO57 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 09:57:59 -0500
Message-ID: <4F33DE6F.80308@linux.vnet.ibm.com>
Date: Thu, 09 Feb 2012 08:55:43 -0600
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: devel@driverdev.osuosl.org, Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Wilk <konrad.wilk@oracle.com>, linux-kernel@vger.kernel.org,
        Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org,
        Brian King <brking@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>
Subject: Re: [PATCH 3/5] staging: zcache: replace xvmalloc with zsmalloc
References: <1326149520-31720-1-git-send-email-sjenning@linux.vnet.ibm.com> <1326149520-31720-4-git-send-email-sjenning@linux.vnet.ibm.com> <20120209011326.GA2225@kroah.com>
In-Reply-To: <20120209011326.GA2225@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020914-9360-0000-0000-0000034F675E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/2012 07:13 PM, Greg KH wrote:
> On Mon, Jan 09, 2012 at 04:51:58PM -0600, Seth Jennings wrote:
>> Replaces xvmalloc with zsmalloc as the persistent memory allocator
>> for zcache
>>
>> Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
> 
> This patch no longer applies :(

Looks like my "staging: zcache: fix serialization bug in zv stats"
patch didn't go in first.  There is an order dependency there.
https://lkml.org/lkml/2012/1/9/403

Let me know if there is still an issue after applying that patch.

Thanks!
--
Seth

