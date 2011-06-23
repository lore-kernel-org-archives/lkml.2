Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933475Ab1FWVn7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 17:43:59 -0400
Received: from gate.crashing.org ([63.228.1.57]:36251 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933154Ab1FWVn4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 17:43:56 -0400
Subject: Re: [PATCH] libata/sas: only set FROZEN flag if new EH is supported
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Brian King <brking@linux.vnet.ibm.com>
Cc: Nishanth Aravamudan <nacc@us.ibm.com>, Tejun Heo <tj@kernel.org>,
        linuxppc-dev@lists.ozlabs.org, wayneb@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        mbizon@freebox.fr, jgarzik@pobox.com
In-Reply-To: <4E039C95.3070907@linux.vnet.ibm.com>
References: <20110615191747.GA6324@us.ibm.com>
	 <4DF90FCA.1040706@linux.vnet.ibm.com> <20110615233417.GB6324@us.ibm.com>
	 <20110616075114.GH8141@htj.dyndns.org>
	 <4DFA0507.3090609@linux.vnet.ibm.com> <20110616152836.GA15268@us.ibm.com>
	 <20110621160714.GA14174@us.ibm.com> <4E00FF58.7070802@linux.vnet.ibm.com>
	 <1308803461.32158.191.camel@pasglop> <1308804120.32158.202.camel@pasglop>
	 <20110623171502.GA11855@us.ibm.com>  <4E039C95.3070907@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 24 Jun 2011 07:43:33 +1000
Message-ID: <1308865413.32158.214.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-23 at 15:05 -0500, Brian King wrote:
> 
> Same here.
> 
> When did this last work on this system? It seems like this is
> completely
> separate from the libata issue. 

It's separate. See my other internal message. This is a BML system and
it's broken as far as 2.6.36 but the BML "patched" kernel works,
anyways, moving that off list for now.

Cheers,
Ben.


