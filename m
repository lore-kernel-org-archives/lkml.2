Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629Ab1JRTbr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 15:31:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5666 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751249Ab1JRTbq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 15:31:46 -0400
Message-ID: <4E9DD418.7030005@redhat.com>
Date: Tue, 18 Oct 2011 14:31:36 -0500
From: David Smith <dsmith@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC PATCH] Tracepoint: add exec tracepoint
References: <4E9DC85F.3080507@redhat.com> <20111018185803.GA32498@infradead.org>
In-Reply-To: <20111018185803.GA32498@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2011 01:58 PM, Christoph Hellwig wrote:

> On Tue, Oct 18, 2011 at 01:41:35PM -0500, David Smith wrote:
>> Added general purpose exec tracepoint.  The 'bprm' argument gives details of the exec.
> 
> Given that you only need the filename from the bprm please just pass
> it directly.


Thanks for looking at the patch.

I'm not totally opposed to this change, but passing bprm allows custom
tracepoint handlers to look at other fields in bprm besides filename,
which could be useful (depending on your needs).

But, I don't have a real strong opinion here.

-- 
David Smith
dsmith@redhat.com
Red Hat
http://www.redhat.com
256.217.0141 (direct)
256.837.0057 (fax)
