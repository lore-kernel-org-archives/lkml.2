Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932786Ab2EDVEy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 17:04:54 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:42060 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932644Ab2EDVEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 17:04:51 -0400
Message-ID: <1336165487.5496.6.camel@ayu>
Subject: Re: [git patches] libata fixes
From: Calvin Walton <calvin.walton@kepstin.ca>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Date: Fri, 04 May 2012 17:04:47 -0400
In-Reply-To: <4FA2CF02.7090708@mvista.com>
References: <20120503182735.GA24318@havoc.gtf.org>
	 <4FA2CF02.7090708@mvista.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-03 at 22:31 +0400, Sergei Shtylyov wrote:
> Hello.
> 
> On 05/03/2012 10:27 PM, Jeff Garzik wrote:
> 
> > Please pull 5f098a3ea72e73ad3733c3280fd5ee04816dc999 from
> > git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git tag/upstream-linus
> 
> 
> > to receive the following updates:
> 
> >   Documentation/devicetree/bindings/ata/ahci-platform.txt |   16 +++++++++++++++
> >   Documentation/devicetree/bindings/ata/calxeda-sata.txt  |   17 ----------------
> 
>     Originally it was a file rename -- did that get preserved?
> 
> WBR, Sergei

Git actually doesn't do any internal tracking of renames, so there is
nothing to be preserved. It detects renames on the fly on the client
when displaying history. (This can be enabled/disabled in the git
config, or using command line options.)

The issue here is apparently just that Jeff forgot to enable rename
detection when generating the diffstat (using e.g. the -M option).

-- 
Calvin Walton <calvin.walton@kepstin.ca>

