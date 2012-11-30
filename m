Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030440Ab2K3NUn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 08:20:43 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56242 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758000Ab2K3NUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 08:20:42 -0500
Date: Fri, 30 Nov 2012 13:20:36 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, grant.likely@secretlab.ca,
        rabin.vincent@stericsson.com, shiraz.hashim@st.com,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, linus.walleij@linaro.org,
        Vipul Kumar Samar <vipulkumar.samar@st.com>
Subject: Re: [PATCH V5 2/2] mfd: stmpe: Update DT support in stmpe driver
Message-ID: <20121130132036.GA23648@gmail.com>
References: <2dcd7cb4c4022fa24b5328974e4226f5aaf89419.1354199865.git.viresh.kumar@linaro.org>
 <121653def4e985b0c1b59045637dd4518f97e73a.1354199865.git.viresh.kumar@linaro.org>
 <20121130105731.GN3176@sortiz-mobl>
 <20121130124518.GF26023@gmail.com>
 <CAKohpomNFmLwf-Gs_mmXV0ULU87-FWCxVGUTfrEM-m6NNt3nPw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKohpomNFmLwf-Gs_mmXV0ULU87-FWCxVGUTfrEM-m6NNt3nPw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Nov 2012, Viresh Kumar wrote:

> On 30 November 2012 18:15, Lee Jones <lee.jones@linaro.org> wrote:
> > The patch doesn't apply for me - does it for you?
> >
> > Viresh, what's it based on?
> 
> Because this was applied 2 days back by Samuel, and i didn't
> fetch it again yesterday:
> 
> commit 20d5c7defc228cdaeff3ce3442f3a4e86af293c1
> Author: Randy Dunlap <rdunlap@infradead.org>
> Date:   Mon Nov 12 09:20:49 2012 -0800
> 
> Its a simple conflict to fix, as this is the only place of conflict.

Eh? You don't know what my tree is based on. ;)

What does this patch apply on top of? Which -rc?

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
