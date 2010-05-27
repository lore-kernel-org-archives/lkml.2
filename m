Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933108Ab0E0WMr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 18:12:47 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:50621 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757351Ab0E0WMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 18:12:46 -0400
Date: Thu, 27 May 2010 23:12:28 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
       STEricsson_nomadik_linux@list.st.com
Subject: Re: [PATCH] DMAENGINE: DMA40 U8500 platform configuration
Message-ID: <20100527221228.GB25484@flint.arm.linux.org.uk>
References: <1274341759-13086-1-git-send-email-linus.walleij@stericsson.com> <AANLkTikmdqceeWNYGm7ZTI64pixtkVWBbpWEtajZGHA1@mail.gmail.com> <AANLkTikiW_yFOqRumd83sETURf-9sI7IfrCmbb5MRjrl@mail.gmail.com> <20100527193755.GA25484@flint.arm.linux.org.uk> <AANLkTimtWrHzbklohUc43hSWPDfJs93YQoQe5Gz4tgUw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimtWrHzbklohUc43hSWPDfJs93YQoQe5Gz4tgUw@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 02:59:51PM -0700, Dan Williams wrote:
> On Thu, May 27, 2010 at 12:37 PM, Russell King <rmk@arm.linux.org.uk> wrote:
> > On Wed, May 26, 2010 at 09:17:42AM -0700, Dan Williams wrote:
> >> Requesting acked-by for:
> >>
> >> http://marc.info/?l=linux-kernel&m=127434177015990&w=2
> >
> > Well...
> >
> >  +const static dma_addr_t dma40_tx_map[STEDMA40_NR_DEV] = {
> >  +const static dma_addr_t dma40_rx_map[STEDMA40_NR_DEV] = {
> 
> Yeah, no need to initialize static data to 0, I'll fix that up before
> submitting.

static const

not

const static

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
