Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965952Ab2B1SAE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 13:00:04 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:47671 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965737Ab2B1SAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 13:00:02 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.201.196 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
Date: Tue, 28 Feb 2012 09:58:35 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Matt Fleming <matt@console-pimps.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>,
        Davidlohr Bueso <dave@gnu.org>
Subject: Re: [RFC][PATCH 6/6] USB: ffs-test: Don't duplicate
 {get,put}_unaligned*() functions
Message-ID: <20120228175835.GA14483@kroah.com>
References: <1330436245-24875-1-git-send-email-matt@console-pimps.org>
 <1330436245-24875-7-git-send-email-matt@console-pimps.org>
 <4F4D13DB.1040205@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F4D13DB.1040205@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 28, 2012 at 09:50:19AM -0800, H. Peter Anvin wrote:
> On 02/28/2012 05:37 AM, Matt Fleming wrote:
> > From: Matt Fleming <matt.fleming@intel.com>
> > 
> > Use the header file in tools/include instead of duplicating the endian
> > functions.
> > 
> > Cc: Davidlohr Bueso <dave@gnu.org>
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Cc: H. Peter Anvin <hpa@zytor.com>
> > Signed-off-by: Matt Fleming <matt.fleming@intel.com>
> 
> Greg and Dave, since the rest of this series is all in the x86
> directory, mind if I pick it up and put it in the -tip tree including
> this patch?

No objection from me at all:
	Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

