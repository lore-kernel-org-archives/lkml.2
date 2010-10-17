Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757058Ab0JQLC2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 07:02:28 -0400
Received: from canuck.infradead.org ([134.117.69.58]:55587 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386Ab0JQLC1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 07:02:27 -0400
Subject: Re: ima: use of radix tree cache indexing == massive waste of
 memory?
From: Peter Zijlstra <peterz@infradead.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>,
        linux-kernel@vger.kernel.org, Mimi Zohar <zohar@us.ibm.com>,
        warthog9@kernel.org, hpa@zytor.com, devel@lists.fedoraprojet.org
In-Reply-To: <1287295077.3020.83.camel@localhost.localdomain>
References: <20101016065206.GO4681@dastard>
	 <20101016192027.GA6883@infradead.org>
	 <1287295077.3020.83.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sun, 17 Oct 2010 13:02:12 +0200
Message-ID: <1287313332.1998.172.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-10-17 at 01:57 -0400, Mimi Zohar wrote:
> On Sat, 2010-10-16 at 15:20 -0400, Christoph Hellwig wrote:
> > Besides the algorithmic problems with ima, why is kernel.org using
> > IMA to start with?  Except for IBM looking for a reason to jusity why
> > TPM isn't a completely waster of ressources it's pointless.  And it was
> > only merged under the premise that it would not affect innocent normal
> > users.
> > 
> 
> Can we keep this at the design level please? When IMA is enabled, it
> needs to store information on a per inode basis, yet has to wait to
> late_initcall() for the TPM, at which point some inodes would have
> already been created.  

Being build (CONFIG_IMA=y) is not the same as default enabled. Is there
a way to build this stuff and not have it enabled?
