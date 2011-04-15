Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087Ab1DOOTa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 10:19:30 -0400
Received: from smtp02.lnh.mail.rcn.net ([207.172.157.102]:39449 "EHLO
	smtp02.lnh.mail.rcn.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964Ab1DOOT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 10:19:29 -0400
X-Greylist: delayed 572 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Apr 2011 10:19:29 EDT
Date: Fri, 15 Apr 2011 10:08:46 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Stratos Psomadakis <psomas@ece.ntua.gr>, linux-kernel@vger.kernel.org
Subject: Re: Two questions about paravirt boot sequence(head_32.S)
Message-ID: <20110415140846.GA32334@dumpdata.com>
References: <4DA6CD8F.6080206@ece.ntua.gr> <8762qhavaa.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8762qhavaa.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 14, 2011 at 09:40:05PM +0930, Rusty Russell wrote:
> On Thu, 14 Apr 2011 13:33:51 +0300, Stratos Psomadakis <psomas@ece.ntua.gr> wrote:
> > 2)I think that xen doesn't use any more the hardware subarch boot
> > parameter, and uses a 'different' path/boot sequence, hence the
> > xen_entry in head_32.S is not needed any more. Am I missing something?
> 
> Yep, Xen never actually used it.

Does lguest use it? It looked like a neat idea - what happened?

