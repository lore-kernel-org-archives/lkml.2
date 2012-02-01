Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801Ab2BATzs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 14:55:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59517 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756650Ab2BATzq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 14:55:46 -0500
Message-ID: <4F299888.40307@redhat.com>
Date: Wed, 01 Feb 2012 12:54:48 -0700
From: Jeff Law <law@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: "Boehm, Hans" <hans.boehm@hp.com>
CC: Torvald Riegel <triegel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        "dsterba@suse.cz" <dsterba@suse.cz>,
        "ptesarik@suse.cz" <ptesarik@suse.cz>,
        "rguenther@suse.de" <rguenther@suse.de>,
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
Subject: Re: Memory corruption due to word sharing
References: <20120201151918.GC16714@quack.suse.cz>	 <CA+55aFy55Q=+pFCZcS9cOM6SL+ZT3sNDB+c4qFvVqwwSpTqJ7g@mail.gmail.com> <1328118174.15992.6206.camel@triegel.csb> <A3E67C2071F49C4CBC4F17E6D77CDDD23275408E@G4W3299.americas.hpqcorp.net>
In-Reply-To: <A3E67C2071F49C4CBC4F17E6D77CDDD23275408E@G4W3299.americas.hpqcorp.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2012 12:44 PM, Boehm, Hans wrote:

> C11 is a published standard.  Last I checked, gcc did not follow many of the above rules.  It looks like major changes were recently merged into the gcc trunk, and I haven't had a chance to test those, so it may well be fixed.  But more importantly, so far I haven't read anything here to dissuade me that they are the right target.

The bitfield changes didn't make it into gcc-4.7; we're still working 
through implementation details.   GCC's bitfield support is a horrid 
nasty mess which has made implementation of the standard problematical. 
   It's on Aldy's plate for gcc-4.8.

jeff
