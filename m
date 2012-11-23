Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759174Ab2KWJkw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 04:40:52 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:64176 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759130Ab2KWJkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 04:40:49 -0500
Date: Fri, 23 Nov 2012 09:40:44 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: sameo@linux.intel.com, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, spear-devel@list.st.com
Subject: Re: [PATCH V2 1/2] mfd: stmpe: Use devm_*() routines
Message-ID: <20121123094044.GF17471@gmail.com>
References: <f1d508c64a01dfd492a1ab1fda28af4b7647d8ab.1353560936.git.viresh.kumar@linaro.org>
 <20121122102710.GD4328@gmail.com>
 <CAKohpo=gctcd5+bZ8xeJn-Cx3=+=+uxaCzEoZhFmp+XaJSpf9Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKohpo=gctcd5+bZ8xeJn-Cx3=+=+uxaCzEoZhFmp+XaJSpf9Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Nov 2012, Viresh Kumar wrote:

> On 22 November 2012 15:57, Lee Jones <lee.jones@linaro.org> wrote:
> > On Thu, 22 Nov 2012, Viresh Kumar wrote:
> >
> >> This patch frees stmpe driver from tension of freeing resources :)
> >> devm_* derivatives of multiple routines are used while allocating resources,
> >> which would be freed automatically by kernel.
> >>
> >> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> 
> > Acked-by: Lee Jones <lee.jones@linaro.org>
> 
> Hi Sameo,
> 
> Please apply this patch only from this series. I will not resend it in
> V3 of my set.

That's not how it works.

Apply my Acked-by yourself and re-send the patch-set as a whole.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
