Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932454Ab1FVTP7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 15:15:59 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46630 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932248Ab1FVTP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 15:15:59 -0400
Date: Wed, 22 Jun 2011 21:15:58 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stefan Assmann <sassmann@kpanic.de>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, tony.luck@intel.com, mingo@elte.hu,
        rick@vanrein.org, rdunlap@xenotime.net, Nancy Yuen <yuenn@google.com>,
        Michael Ditto <mditto@google.com>
Subject: Re: [PATCH v2 0/3] support for broken memory modules (BadRAM)
Message-ID: <20110622191558.GI3263@one.firstfloor.org>
References: <1308741534-6846-1-git-send-email-sassmann@kpanic.de> <20110622110034.89ee399c.akpm@linux-foundation.org> <20110622182445.GG3263@one.firstfloor.org> <20110622113851.471f116f.akpm@linux-foundation.org> <20110622185645.GH3263@one.firstfloor.org> <4E023CE3.70100@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E023CE3.70100@zytor.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 22, 2011 at 12:05:07PM -0700, H. Peter Anvin wrote:
> On 06/22/2011 11:56 AM, Andi Kleen wrote:
> > 
> > You'll always have multiple ways. Whatever magic you come up for
> > the google BIOS or for EFI won't help the majority of users with
> > old crufty legacy BIOS.
> > 
> 
> I don't think this has anything to do with this.

Please elaborate.

How would you pass the bad page information instead in a fully backwards
compatible way?

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
