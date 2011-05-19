Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933401Ab1ESPPX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 11:15:23 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:36550 "EHLO duck.linux-mips.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933014Ab1ESPPV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 11:15:21 -0400
Date: Thu, 19 May 2011 16:15:14 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Kevin Cernekee <cernekee@gmail.com>
Cc: dediao@cisco.com, ddaney@caviumnetworks.com, dvomlehn@cisco.com,
        sshtylyov@mvista.com, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] MIPS: HIGHMEM DMA on noncoherent MIPS32 processors
Message-ID: <20110519151514.GA11887@linux-mips.org>
References: <002fbbeb01a5a51fff8015af85d5d101@localhost>
 <20110519110638.GA11371@linux-mips.org>
 <BANLkTikouHA-Owkqji5W4sYdZ2nFrT_==g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTikouHA-Owkqji5W4sYdZ2nFrT_==g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 08:05:24AM -0700, Kevin Cernekee wrote:

> On Thu, May 19, 2011 at 4:06 AM, Ralf Baechle <ralf@linux-mips.org> wrote:
> > Who is the author of this patch, you or Dezhong Diao?
> 
> The author is Dezhong... I should have added the extra "From:" header.

Thanks.  I fixed up the author attribution and queued the patch for 2.6.41.

  Ralf
