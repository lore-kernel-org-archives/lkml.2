Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211Ab2AOOEW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 09:04:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22217 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751219Ab2AOOEU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 09:04:20 -0500
Message-ID: <4F12DCDA.7040706@redhat.com>
Date: Sun, 15 Jan 2012 16:04:10 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: dave@gnu.org
CC: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        lkml <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: MMU: increment stats after event occurrence
References: <1326416880.3416.2.camel@offbook>  <4F0F87BE.2020202@oss.ntt.co.jp> <1326459360.3231.3.camel@offbook>
In-Reply-To: <1326459360.3231.3.camel@offbook>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2012 02:56 PM, Davidlohr Bueso wrote:
> On Fri, 2012-01-13 at 10:24 +0900, Takuya Yoshikawa wrote:
> > (2012/01/13 10:08), Davidlohr Bueso wrote:
> > > From: Davidlohr Bueso<dave@gnu.org>
> > >
> > > It makes more sense to actually increment statistics for tlb flushes and page table entry updates after such _events_ occur, instead of before.
> > 
> > Why?
> > 
> From a logical point of view its better to increase stats once the event
> is processed - usually because it can fail and therefore the stats would
> be incorrect. 
>

That doesn't hold for the cases you change.

-- 
error compiling committee.c: too many arguments to function

