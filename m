Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518Ab2CYAn0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 20:43:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47275 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338Ab2CYAnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 20:43:25 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] of/irq: add empty irq_of_parse_and_map() for non-dt builds
To: Thomas Abraham <thomas.abraham@linaro.org>,
        Rob Herring <robherring2@gmail.com>
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        patches@linaro.org
In-Reply-To: <CAJuYYwQfNNO94_9nQnXH3xEoP6aWSJi4Hcpuh82N2xfGKJ4OnA@mail.gmail.com>
References: <1332581257-15989-1-git-send-email-thomas.abraham@linaro.org> <4F6DC847.8000902@gmail.com> <CAJuYYwR92M7faLaZxT8ycKZB=ORf5J8fELwFENaL_GK7dtG7ew@mail.gmail.com> <CAJuYYwQfNNO94_9nQnXH3xEoP6aWSJi4Hcpuh82N2xfGKJ4OnA@mail.gmail.com>
Date: Sat, 24 Mar 2012 17:43:22 -0700
Message-Id: <20120325004322.909163E0409@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Mar 2012 21:42:00 +0530, Thomas Abraham <thomas.abraham@linaro.org> wrote:
> On 24 March 2012 21:37, Thomas Abraham <thomas.abraham@linaro.org> wrote:
> > On 24 March 2012 18:42, Rob Herring <robherring2@gmail.com> wrote:
> >> On 03/24/2012 04:27 AM, Thomas Abraham wrote:
> >>> Add a empty irq_of_parse_and_map() that returns 0 for non-dt builds and
> >>> avoid having #ifdef CONFIG_OF around all calls to irq_of_parse_and_map().
> >>>
> >>> Suggested-by: Grant Likely <grant.likely@secretlab.ca>
> >>> Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
> >>> ---
> >>
> >> Acked-by: Rob Herring <rob.herring@calxeda.com>
> >>
> >> Go ahead and merge with the rest of your series.
> >>
> >> Rob
> >
> > Thanks Rob. It would be good if this patch goes via Grant's
> > devicetree/next. The other patch series that I have posted would go
> > via Samsung maintainer's dt-branch into which this patch can be merged
> > from Grant's devicetree/next.

As replied to on original patch, this isn't necessary.  Just merge it
via the Samsung tree since you've already got my acked-by on it.

g.

