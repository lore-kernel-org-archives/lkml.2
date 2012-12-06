Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978Ab2LFLeA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 06:34:00 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:49275 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423283Ab2LFLd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 06:33:57 -0500
Date: Thu, 6 Dec 2012 11:33:51 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Samuel Ortiz <sameo@linux.intel.com>, rabin.vincent@stericsson.com,
        shiraz.hashim@st.com, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, spear-devel@list.st.com,
        linus.walleij@linaro.org, Vipul Kumar Samar <vipulkumar.samar@st.com>
Subject: Re: [PATCH V5 2/2] mfd: stmpe: Update DT support in stmpe driver
Message-ID: <20121206113351.GS2718@gmail.com>
References: <20121205224203.691153E0E22@localhost>
 <CAKohponjLp214EPKgNHqP2N8Tje9U8ZxgywUTSvsjE-TqHy+xw@mail.gmail.com>
 <20121206095019.GN2718@gmail.com>
 <CAKohpokNQB6L2vvjmvA7_3KomFXnV9wZ-uBjrfRVuBL=QWgr_Q@mail.gmail.com>
 <20121206101131.GP2718@gmail.com>
 <CAKohpom9NK0Tg9fKdddkP-0H8FuVd-=yhHzZr-sWNb_zTVymWw@mail.gmail.com>
 <20121206103515.GQ2718@gmail.com>
 <CAKohponeU539FR+XCKJQTFnoNKJCnAh5ESB1NGP7ZK0u4Tqwyg@mail.gmail.com>
 <20121206111252.GR2718@gmail.com>
 <CAKohponrZ8a+=ozXox60nRVBO174Nr=GoSjKkkz7KjLCxd5BhQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKohponrZ8a+=ozXox60nRVBO174Nr=GoSjKkkz7KjLCxd5BhQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 06 Dec 2012, Viresh Kumar wrote:

> On 6 December 2012 16:42, Lee Jones <lee.jones@linaro.org> wrote:
> > I thought we'd be over this? The 'ID' will be represented by the
> > address of the chip i.e. stmpe1601@40, where '40' will be
> > distinguishing factor?
> 
> I haven't tested it but i thought we are getting i2c device name from
> modalias() fn running on "st,stmpe1601" and so would give us "stmpe1601".
> 
> Now, i went back to your earlier mail and checked device name:
> stmpe-i2c 0-0040: stmpe1601 detected, chip id: 0x212
> 
> It came from DT :)
> 
> So, probably no more issues of id's. Will resend my patch, after getting
> rid of tables.

Now we're talking!

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
