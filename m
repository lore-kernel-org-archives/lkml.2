Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158Ab0FGSRO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 14:17:14 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:47599 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763Ab0FGSRM (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 7 Jun 2010 14:17:12 -0400
Date: Mon, 7 Jun 2010 14:14:55 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       pjones@redhat.com, mchristie@redhat.com
Subject: Re: Linux 2.6.35-rc2
Message-ID: <20100607181455.GB16928@phenom.dumpdata.com>
References: <alpine.LFD.2.00.1006052050100.3515@i5.linux-foundation.org> <20100607163746.GB13468@phenom.dumpdata.com> <alpine.LFD.2.00.1006070939210.3515@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1006070939210.3515@i5.linux-foundation.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090203.4C0D3796.0005:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 07, 2010 at 09:40:33AM -0700, Linus Torvalds wrote:
> 
> 
> On Mon, 7 Jun 2010, Konrad Rzeszutek Wilk wrote:
> > 
> > I am wondering what about git pull request that were sent before this
> > email but haven't been addressed yet? Specifically I am concerned
> > about: http://lkml.org/lkml/2010/6/2/301
> 
> It was sent to me after the merge window already closed, and seemed to 
> be about just new features. As a result, I entirely ignored it.

Ah, <sigh> I seem to have a knack for continously missing the merge
windows. Is it fair to state that:

 1). Once you send an email saying that Linux 2.6.35 is released, the
     merge window has opened.
 2). Then the the maintainers have two weeks to send you git pull
     request for new features.
 3). After the two weeks, it is rc1, and only bug-fixes are accepted?
