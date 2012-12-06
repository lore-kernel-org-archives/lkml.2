Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926Ab2LFKfW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 05:35:22 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:55464 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447Ab2LFKfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 05:35:21 -0500
Date: Thu, 6 Dec 2012 10:35:15 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Samuel Ortiz <sameo@linux.intel.com>, rabin.vincent@stericsson.com,
        shiraz.hashim@st.com, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, spear-devel@list.st.com,
        linus.walleij@linaro.org, Vipul Kumar Samar <vipulkumar.samar@st.com>
Subject: Re: [PATCH V5 2/2] mfd: stmpe: Update DT support in stmpe driver
Message-ID: <20121206103515.GQ2718@gmail.com>
References: <121653def4e985b0c1b59045637dd4518f97e73a.1354199865.git.viresh.kumar@linaro.org>
 <20121130105731.GN3176@sortiz-mobl>
 <20121130154542.GG23648@gmail.com>
 <CAKohpokLVEH+4F_VXh5auUm48cWWe0mumZME8yOCcAezcwJbCQ@mail.gmail.com>
 <20121205224203.691153E0E22@localhost>
 <CAKohponjLp214EPKgNHqP2N8Tje9U8ZxgywUTSvsjE-TqHy+xw@mail.gmail.com>
 <20121206095019.GN2718@gmail.com>
 <CAKohpokNQB6L2vvjmvA7_3KomFXnV9wZ-uBjrfRVuBL=QWgr_Q@mail.gmail.com>
 <20121206101131.GP2718@gmail.com>
 <CAKohpom9NK0Tg9fKdddkP-0H8FuVd-=yhHzZr-sWNb_zTVymWw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKohpom9NK0Tg9fKdddkP-0H8FuVd-=yhHzZr-sWNb_zTVymWw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 06 Dec 2012, Viresh Kumar wrote:

> On 6 December 2012 15:41, Lee Jones <lee.jones@linaro.org> wrote:
> > So then I'm back to my original question, why?
> >
> > What is it used for? What difference does it make?
> >
> > I could understand if the .data attribute was used in the driver
> > to make vital decisions based on STMPE version, but it's not. So
> > why are we burdening the driver with unused code that's not
> > required? Other than to get your mainlined patch-count up of
> > course? This has an air of "placing header files in alphabetical
> > order" about it. ;)
> 
> The count would still be the same as some part of this patch will
> go :)
> 
> I said that because of Grant's comment: "An of_match_table is the
> robust way of identifying specific devices and allows for matching
> against any entry in the compatible list."
> 
> So, thought its better we keep it.

Only if you're going to use it, or else it's just unused cruft.

> Now, the problem is, with this new table we will bind device and
> driver based on of_device_id table and probe it using device_id
> table. Ahh.. that's broken. Maybe yes, can remove it unless we
> have a real need of it.

Broken or otherwise, if it's unused, it's cruft. :)

> >> By chance
> >> our non-DT and DT tables had a difference of "st," only in the name
> >> of instances and so it worked without tables. Otherwise it couldn't
> >> have worked.
> >>
> >> Over that, i am looking to bring the "stmpe,id" binding back again (unless
> >> you have a better option), as device name is not coming from DT currently,
> >> which we discussed earlier.
> >
> > Or you could not put unnecessary bindings into the Device Tree
> > by putting two and two together and realise that using the table
> > is the correct thing to do instead. This actually gives reason
> > to you previous patch, but should probably be fixed-up into it
> > so it has some proper meaning/purpose. ;)
> 
> Couldn't understand this one :(

Really?

Let's break it down - what do you need "stmpe,id" for?

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
