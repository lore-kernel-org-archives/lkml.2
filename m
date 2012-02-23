Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932234Ab2BWXSP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 18:18:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58071 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756141Ab2BWXSN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 18:18:13 -0500
Message-ID: <4F46C92B.4090508@zytor.com>
Date: Thu, 23 Feb 2012 15:18:03 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>, stable@vger.kernel.org,
        Raphael Prevost <raphael@buro.asia>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] i387: stable kernel backport
References: <alpine.LFD.2.02.1202221252060.20522@i5.linux-foundation.org> <20120222211928.GA4448@kroah.com> <CA+55aFz0pOO6j9s3Gs2UJLM4zm8SuPgi5iUiVAaPCp9Xh2Pvjw@mail.gmail.com> <20120222213253.GA25150@kroah.com> <20120223200905.GA5475@kroah.com> <4F46A1C4.90506@zytor.com> <20120223204832.GA30322@kroah.com> <4F46A6EC.8050804@zytor.com> <20120223211016.GA16275@kroah.com> <4F46C63C.4040602@zytor.com> <20120223231605.GA15329@kroah.com>
In-Reply-To: <20120223231605.GA15329@kroah.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23/2012 03:16 PM, Greg Kroah-Hartman wrote:
> 
> And a "clean" 3.2.7 doesn't have that problem?
> 
> Does the same thing happen in Linus's tree at the moment?
> 

Clean 3.2.7 I don't think has that problem, although of course when I
run the stress test it fails on other ways so it's hard to 100% rule out.

Linus' tree doesn't have that problems.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

