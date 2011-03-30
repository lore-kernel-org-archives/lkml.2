Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965212Ab1C3VbG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:31:06 -0400
Received: from one.firstfloor.org ([213.235.205.2]:40805 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965040Ab1C3VbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:31:03 -0400
Date: Wed, 30 Mar 2011 23:31:01 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>, ak@linux.intel.com, guichaz@gmail.com,
        srajiv@linux.vnet.ibm.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: Re: [PATCH] [73/275] tpm_tis: Use timeouts returned from TPM
Message-ID: <20110330213101.GF21838@one.firstfloor.org>
References: <20110330203.501921634@firstfloor.org> <20110330210510.8AF143E1A05@tassilo.jf.intel.com> <4D939CE5.1090405@linux.vnet.ibm.com> <20110330212057.GE21838@one.firstfloor.org> <4D939F78.7030206@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D939F78.7030206@linux.vnet.ibm.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30, 2011 at 05:24:08PM -0400, Stefan Berger wrote:
> On 03/30/2011 05:20 PM, Andi Kleen wrote:
> >On Wed, Mar 30, 2011 at 05:13:09PM -0400, Stefan Berger wrote:
> >>On 03/30/2011 05:05 PM, Andi Kleen wrote:
> >>
> >>Please drop it. It has been rejected previously. A revised patch has
> >>been sent.
> >Ok. What is the subject of the revised patch?
> It's part of a series I re-posted again today:
> 
> [PATCH V2 00/12] tpm + tpm_tis : Various fixes
> 
> https://lkml.org/lkml/2011/3/30/290

I don't see a cc stable so I assume you don't want that in 2.6.35.
I dropped the original patch.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
