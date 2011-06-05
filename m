Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331Ab1FEIPE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 04:15:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63611 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754228Ab1FEIPB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 04:15:01 -0400
Message-ID: <4DEB3AE4.8040700@redhat.com>
Date: Sun, 05 Jun 2011 11:14:28 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Brad Campbell <lists2009@fnarfbargle.com>
CC: CaT <cat@zip.com.au>, Hugh Dickins <hughd@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Borislav Petkov <bp@alien8.de>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-mm <linux-mm@kvack.org>, netdev <netdev@vger.kernel.org>
Subject: Re: KVM induced panic on 2.6.38[2367] & 2.6.39
References: <20110601011527.GN19505@random.random> <alpine.LSU.2.00.1105312120530.22808@sister.anvils> <4DE5DCA8.7070704@fnarfbargle.com> <4DE5E29E.7080009@redhat.com> <4DE60669.9050606@fnarfbargle.com> <4DE60918.3010008@redhat.com> <4DE60940.1070107@redhat.com> <4DE61A2B.7000008@fnarfbargle.com> <20110601111841.GB3956@zip.com.au> <4DE62801.9080804@fnarfbargle.com> <20110601230342.GC3956@zip.com.au> <4DE8E3ED.7080004@fnarfbargle.com>
In-Reply-To: <4DE8E3ED.7080004@fnarfbargle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2011 04:38 PM, Brad Campbell wrote:
>
> Is there anyone who can point me at the appropriate cage to rattle? I 
> know it appears to be a netfilter issue, but I don't seem to be able 
> to get a message to the list (and I am subscribed to it and have been 
> getting mail for months) and I'm not sure who to pester. The other 
> alternative is I just stop doing "that" and wait for it to bite 
> someone else.

The mailing list might be set not to send your own mails back to you.  
Check the list archive.

-- 
error compiling committee.c: too many arguments to function

