Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934165Ab2JZVpZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 17:45:25 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:44353 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965277Ab2JZVpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 17:45:24 -0400
Message-ID: <508B046A.6050006@linux.vnet.ibm.com>
Date: Fri, 26 Oct 2012 16:45:14 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: Konrad Wilk <konrad.wilk@oracle.com>, Mel Gorman <mgorman@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RFC] mm: add support for zsmalloc and zcache
References: <1346794486-12107-1-git-send-email-sjenning@linux.vnet.ibm.com> <20120921161252.GV11266@suse.de> <20120921180222.GA7220@phenom.dumpdata.com> <505CB9BC.8040905@linux.vnet.ibm.com> <42d62a30-bd6c-4bd7-97d1-bec2f237756b@default> <50609794.8030508@linux.vnet.ibm.com> <b34c65c9-4b25-431d-8b82-cbe911126be9@default> <5064B647.3000906@linux.vnet.ibm.com> <76d1a3f1-efc5-48b5-b485-604a94adcc1d@default> <506B2C4B.3080508@linux.vnet.ibm.com> <771b722f-3036-451a-a416-e6ab5b4a05f7@default>
In-Reply-To: <771b722f-3036-451a-a416-e6ab5b4a05f7@default>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12102621-2876-0000-0000-0000016750DC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2012 01:17 PM, Dan Magenheimer wrote:
> If so, <shake hands> and move forward?  What do you see as next steps?

I've been reviewing the changes between zcache and zcache2 and getting
a feel for the scope and direction of those changes.

- Getting the community engaged to review zcache1 at ~2300SLOC was
  difficult.
- Adding RAMSter has meant adding RAMSter-specific code broadly across
  zcache and increases the size of code to review to ~7600SLOC.
- The changes have blurred zcache's internal layering and increased
  complexity beyond what a simple SLOC metric can reflect.
- Getting the community engaged in reviewing zcache2 will be difficult
  and will require an exceptional amount of effort for maintainer and
  reviewer.

It is difficult for me to know when it could be ready for mainline and
production use.  While zcache2 isn't getting broad code reviews yet,
how do suggest managing that complexity to make the code maintainable
and get it reviewed?

Seth

