Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933038Ab1DZXEU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 19:04:20 -0400
Received: from mga11.intel.com ([192.55.52.93]:64986 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932911Ab1DZXET (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 19:04:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,271,1301900400"; 
   d="scan'208";a="684369626"
Date: Tue, 26 Apr 2011 16:03:27 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Andi Kleen <andi@firstfloor.org>, bp@amd64.org, greg@kroah.com,
        borislav.petkov@amd.com, stable@kernel.org, gregkh@suse.de,
        linux-kernel@vger.kernel.org, tim.bird@am.sony.com
Subject: Re: [PATCH] [42/106] x86, microcode, AMD: Extend ucode size
 verification
Message-ID: <20110426230326.GA16968@tassilo.jf.intel.com>
References: <20110426212.641772347@firstfloor.org>
 <20110426211321.EC7513E1886@tassilo.jf.intel.com>
 <BANLkTikH1DCGKR=iE4ch9hQQihzhyn0e+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTikH1DCGKR=iE4ch9hQQihzhyn0e+g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 06:44:05PM -0400, Paul Gortmaker wrote:
> On Tue, Apr 26, 2011 at 5:13 PM, Andi Kleen <andi@firstfloor.org> wrote:
> > 2.6.35-longterm review patch.  If anyone has any objections, please let me know.
> 
> Minor nit, but git am complains about whitespace in this backport.  I checked
> the original, and at a glance it looks OK in this respect.
> 
> (42/106) Applying: x86, microcode, AMD: Extend ucode size verification
> /home/paul/git/stable/linux-2.6.35.y/.git/rebase-apply/patch:95: space
> before tab in indent.
>  		return NULL;
> /home/paul/git/stable/linux-2.6.35.y/.git/rebase-apply/patch:100:
> trailing whitespace.
> 	
> warning: 2 lines add whitespace errors.

I ran cleanpatch over it.

-Andi

