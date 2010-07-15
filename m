Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934743Ab0GOVw6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 17:52:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58588 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934092Ab0GOVw5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 17:52:57 -0400
Date: Thu, 15 Jul 2010 17:52:50 -0400
From: Dave Jones <davej@redhat.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, x86@kernel.org
Subject: Re: Make CONFIG_DEBUG_RODATA boot-time configurable
Message-ID: <20100715215249.GB19664@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, x86@kernel.org
References: <20100715210944.GA24961@redhat.com>
 <20100715143525.987dc8f4.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100715143525.987dc8f4.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 15, 2010 at 02:35:25PM -0700, Randy Dunlap wrote:
 
 > > diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
 > > index 4ddb58d..1320d80 100644
 > > --- a/Documentation/kernel-parameters.txt
 > > +++ b/Documentation/kernel-parameters.txt
 > > @@ -651,6 +651,10 @@ and is between 256 and 4096 characters. It is defined in the file
 > >  			MTRR settings.  This parameter disables that behavior,
 > >  			possibly causing your machine to run very slowly.
 > >  
 > > +	disable_rodata [X86]
 > 
 > What is X86-specific about this boot option?

Just hadn't realized that other archs had implemented it.

	Dave

