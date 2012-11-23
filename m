Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759095Ab2KWJgk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 04:36:40 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:40315 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759041Ab2KWJgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 04:36:39 -0500
Date: Fri, 23 Nov 2012 09:36:33 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: sameo@linux.intel.com, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, spear-devel@list.st.com,
        Vipul Kumar Samar <vipulkumar.samar@st.com>
Subject: Re: [PATCH V2 2/2] mfd: stmpe: Extend DT support in stmpe driver
Message-ID: <20121123093633.GD17471@gmail.com>
References: <f1d508c64a01dfd492a1ab1fda28af4b7647d8ab.1353560936.git.viresh.kumar@linaro.org>
 <b81641051dad9660b72b0028d001e5620d901160.1353560936.git.viresh.kumar@linaro.org>
 <20121122112451.GE4328@gmail.com>
 <CAKohpo=EWFNddjMNwHO4u4-bi1AQ4cvsJ4DfFOgaFv3oVfheZg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKohpo=EWFNddjMNwHO4u4-bi1AQ4cvsJ4DfFOgaFv3oVfheZg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Nov 2012, Viresh Kumar wrote:

> On 22 November 2012 16:54, Lee Jones <lee.jones@linaro.org> wrote:
> >> diff --git a/Documentation/devicetree/bindings/mfd/stmpe.txt b/Documentation/devicetree/bindings/mfd/stmpe.txt
> >>       stmpe1601: stmpe1601@40 {
> 
> >> +             id = <0>;
> >
> > Don't do this. Device IDs are Linux specific.
> 
> Hi Lee,
> 
> This is id of the mfd device that we need to pass to mfd_add_device()
> and is used in following:

MFD devices are Linux specific, whereas DT is cross-platform. Thus
you can't put it in the DTS(I) files.

> 	pdev = platform_device_alloc(cell->name, id + cell->id);
> 
> This is required when we have multiple instances of MFD device present
> on board. How do you want me to handle this ?

There are lots of examples of this already. I have to leave something
to the imagination, or I'll be requesting a cut of your salary. :D

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
