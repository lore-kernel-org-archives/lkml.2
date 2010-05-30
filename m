Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704Ab0E3J1a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 05:27:30 -0400
Received: from one.firstfloor.org ([213.235.205.2]:41373 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130Ab0E3J12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 05:27:28 -0400
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: James Bottomley <James.Bottomley@suse.de>,
       Christoph Hellwig <hch@infradead.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Mike Christie <michaelc@cs.wisc.edu>, Douglas@firstfloor.org,
       Gilbe@firstfloor.org, linux-scsi <linux-scsi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC]: Mainline of TCM Core and TCM_Loop for v2.6.35
From: Andi Kleen <andi@firstfloor.org>
References: <1274317792.30733.59.camel@haakon2.linux-iscsi.org>
Date: Sun, 30 May 2010 11:27:26 +0200
In-Reply-To: <1274317792.30733.59.camel@haakon2.linux-iscsi.org> (Nicholas A. Bellinger's message of "Wed\, 19 May 2010 18\:09\:52 -0700")
Message-ID: <87vda5zqm9.fsf@basil.nowhere.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Nicholas A. Bellinger" <nab@linux-iscsi.org> writes:
>
> As always, I am open to constructive suggestions,

Your description contains quite a lot of acronyms (I count 8 in the first
paragraph alone). For the benefit of the linux-kernel audience which are
not storage experts and are struggling to find out what this is all good
for, how about including a glossary that explains what it all means?  I
suspect having that in the git commit log later will be also useful.

Thanks,

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
