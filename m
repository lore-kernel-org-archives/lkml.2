Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759Ab0JGVqj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 17:46:39 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:54108 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268Ab0JGVqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 17:46:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=i7hC4yKlSKcDQvKYy5Fy/qGQHa1nHQWuIzD8K5vMh94dgzgGpFZgZOIWh7WKnPuXks
         L3lnHMKhpS3DVD/FatfS8bCcqwtekd3WoPveAc42RDwVm1I40yhi7PBg474Yguql0TDz
         zEyixRhDfKpcp7PA/6FBvVMFBsCCdUmDvoNzM=
Date: Thu, 7 Oct 2010 14:46:28 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Mario Limonciello <superm1@ubuntu.com>,
        Keng-Yu Lin <keng-yu.lin@canonical.com>, len.brown@intel.com,
        alan-jenkins@tuffmail.co.uk, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dell-laptop: Add hwswitch_only module parameter
Message-ID: <20101007214628.GB18628@core.coreip.homeip.net>
References: <1286422207-14248-1-git-send-email-keng-yu.lin@canonical.com>
 <20101007111510.GA19624@srcf.ucam.org>
 <AANLkTinus8SxbXt14qabXgpbFXF4U+uNoKA-=eDuOjmp@mail.gmail.com>
 <20101007133529.GA21782@srcf.ucam.org>
 <AANLkTi=kTQpTkCF6-DE+LdNLH_aki9bD9NPF0L2qRr=Q@mail.gmail.com>
 <20101007205049.GB32726@srcf.ucam.org>
 <AANLkTi=bj3T5hcX9r3j5kyEQkNb7PAZK948kcrx4R8tC@mail.gmail.com>
 <20101007213027.GA18628@core.coreip.homeip.net>
 <20101007213754.GA1896@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101007213754.GA1896@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 07, 2010 at 10:37:54PM +0100, Matthew Garrett wrote:
> On Thu, Oct 07, 2010 at 02:30:28PM -0700, Dmitry Torokhov wrote:
> 
> > We have this strategy for bunch of input stuff (force release, keymap)
> > and I think it works better than dding more and more DMI quirks into
> > kernel itself.
> 
> It's limited to Dell hardware, so I think keeping a static list in the 
> Dell laptop driver is reasonable. All we need is a list of hardware, and 
> I'd really hope that Dell know which BIOS versions contain this code!
> 

Unfortunately this kind of crap tends to flow from one BIOS version to
another.. How many DMI entries do we know about so far? Did Dell issue
firmware updates correcting the issue so new boxes will not exhibit the
problem?

-- 
Dmitry
