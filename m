Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281Ab2IVNbm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 09:31:42 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:40984 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260Ab2IVNbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 09:31:41 -0400
Message-ID: <505DBDC5.3010503@gmail.com>
Date: Sat, 22 Sep 2012 15:31:49 +0200
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120913 Thunderbird/15.0.1
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: Mel Gorman <mgorman@suse.de>, Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [RFC] mm: add support for zsmalloc and zcache
References: <1346794486-12107-1-git-send-email-sjenning@linux.vnet.ibm.com> <20120921161252.GV11266@suse.de> <15c1d12a-0e29-478f-97e0-ee4063e2cba5@default>
In-Reply-To: <15c1d12a-0e29-478f-97e0-ee4063e2cba5@default>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/2012 09:14 PM, Dan Magenheimer wrote:
>>> +#define MAX_CLIENTS 16
>> > 
>> > Seems a bit arbitrary. Why 16?
> Sasha Levin posted a patch to fix this but it was tied in to
> the proposed KVM implementation, so was never merged.
> 

My patch changed the max pools per client, not the maximum amount of clients.
That patch has already found it's way in.

(MAX_CLIENTS does look like an arbitrary number though).


Thanks,
Sasha
