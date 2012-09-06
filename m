Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759363Ab2IFRO2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 13:14:28 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:17370 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755301Ab2IFRO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 13:14:27 -0400
Subject: Re: [PATCH v2] Add missing attributes to EFI variable attribute
 print out from sysfs
From: Khalid Aziz <khalid.aziz@hp.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, tony.luck@intel.com, mikew@google.com,
        keescook@chromium.org, gong.chen@linux.intel.com
In-Reply-To: <20120713175036.GB18496@srcf.ucam.org>
References: <20120713174216.GA10445@hp.com>
	 <20120713175036.GB18496@srcf.ucam.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 06 Sep 2012 11:14:25 -0600
Message-ID: <1346951665.20255.66.camel@lyra>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-07-13 at 18:50 +0100, Matthew Garrett wrote:
> On Fri, Jul 13, 2012 at 11:42:16AM -0600, Khalid Aziz wrote:
> > Some of the EFI variable attributes are missing from print out from
> > /sys/firmware/efi/vars/*/attributes. This patch adds those in. It also
> > updates code to use pre-defined constants for masking current value
> > of attributes.
> > 
> > Signed-off-by: Khalid Aziz <khalid.aziz@hp.com>
> > Cc: stable@vger.kernel.org
> Acked-by: Matthew Garrett <mjg@redhat.com>

I have not seen this patch show up in linux-next or 3.6-rc*. Do I need
to do anything more to get this patch integrated?

Thanks
-- 
Khalid Aziz <khalid.aziz@hp.com>

