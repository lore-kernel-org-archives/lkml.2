Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932515Ab2IGHkJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 03:40:09 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:45697 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758505Ab2IGHkH convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:2>);
	Fri, 7 Sep 2012 03:40:07 -0400
Message-Id: <5049C12B020000780009998C@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 07 Sep 2012 08:40:59 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Vasco Dias" <rafa.vasco@gmail.com>,
        "Matt Fleming" <matt.fleming@intel.com>,
        "Matthew Garrett" <mjg@redhat.com>, <linux-efi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <cJ-ko@zougloub.eu>
Subject: Re: [PATCH] x86, efi: 1:1 pagetable mapping for virtual EFI
 calls
References: <1346937309-1581-1-git-send-email-matt@console-pimps.org>
 <5048D09A020000780009965B@nat28.tlf.novell.com>
 <1346946465.4244.107.camel@mfleming-mobl1.ger.corp.intel.com>
 <5048D83D.8000408@zytor.com>
In-Reply-To: <5048D83D.8000408@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 06.09.12 at 19:07, "H. Peter Anvin" <hpa@zytor.com> wrote:
> Anyone care to refresh my memory why we can't use the "global" 
> 1:1+kernel map, possibly with some improvements (which would benefit the 
> users of those maps too)?  With that I mean initial_page_map on i386 and 
> trampoline_pgd on x86-64...

I don't think you want anything inserted in the low part of those
(kernel-only) page tables, not even transiently.

Jan

