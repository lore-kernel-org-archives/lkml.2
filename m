Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993144Ab2KOI6k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 03:58:40 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:16379 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992592Ab2KOI6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 03:58:37 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-ce-50a4aebc5486
From: Jingoo Han <jg1.han@samsung.com>
To: "'Thierry Reding'" <thierry.reding@avionic-design.de>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Florian Tobias Schandinat'" <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
References: <1352469878-4532-1-git-send-email-thierry.reding@avionic-design.de>
 <004201cdc2d0$c1920210$44b60630$%han@samsung.com>
 <20121115065140.GA21208@avionic-0098.mockup.avionic-design.de>
In-reply-to: <20121115065140.GA21208@avionic-0098.mockup.avionic-design.de>
Subject: Re: [PATCH] backlight: Add of_find_backlight_by_node() function
Date: Thu, 15 Nov 2012 17:58:35 +0900
Message-id: <001201cdc30f$65a17be0$30e473a0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3C/bTVpgTGWvaYTTa9liMVzdC1FAAD4a1w
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsVy+t8zA90965YEGPxfKGhxou8Dq8XlXXPY
	HJg8Pm+SC2CM4rJJSc3JLEst0rdL4Mr4/ng/a8EhnopFq8+wNjAe5+xi5OSQEDCRmLl/BwuE
	LSZx4d56ti5GLg4hgWWMEj2XXzDDFL16eZEZIrGIUeJE5yYmkISQwC9GiXkXy0FsNgE1iS9f
	DrOD2CIC5hJLFu0Fa2AW+Moo0fikgQ2i4QijxMYP8V2MHBycAt4Sc/Zwg4SFBTwkNl/+ClbC
	IqAq0XkSZDEHB6+ArcT8V/ogYV4BQYkfk++BHcosoCWxfudxJghbXmLzmrdg5RIC6hKP/upC
	XGAkcWjtKUaIEhGJfS/eMUJMF5D4NvkQC0S5rMSmA2BHSghsYpeYu2IPI8S7khIHV9xgmcAo
	MQvJ5llINs9CsnkWkhULGFlWMYqmFiQXFCel5xrqFSfmFpfmpesl5+duYoREmNQOxpUNFocY
	BTgYlXh4HX4sDhBiTSwrrsw9xCjBwawkwhu1dkmAEG9KYmVValF+fFFpTmrxIUYfoMsnMkuJ
	JucDoz+vJN7Q2NjEzMTUxNzS1NwUh7CSOG+zR0qAkEB6YklqdmpqQWoRzDgmDk6pBsZY2aCE
	nVLfeJpWGx1KjwnsZ2M8oBu6V+3WhnQFK6+Ezu+e6svd5tTVdCfMexo/i08r6Nf5tW5d+eIS
	Nxw/fmH8Y20hoZjR7vvVvUPl9/4Od6YtE26dXN2i8dS5teE5v0dfZedL7iksMbqu8b7zOPvj
	Z7ruF9sZmlpfIXFtqn3kYue9qZuXKLEUZyQaajEXFScCACZ6GRPdAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJIsWRmVeSWpSXmKPExsVy+t9jAd0965YEGJz+ymtxou8Dq8XlXXPY
	HJg8Pm+SC2CMamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ
	0HXLzAEaraRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPM+P54P2vBIZ6K
	RavPsDYwHufsYuTkkBAwkXj18iIzhC0mceHeerYuRi4OIYFFjBInOjcxgSSEBH4xSsy7WA5i
	swmoSXz5cpgdxBYRMJdYsmgvM0gDs8BXRonGJw1sEA1HGCU2fojvYuTg4BTwlpizhxskLCzg
	IbH58lewEhYBVYnOky+YQUp4BWwl5r/SBwnzCghK/Jh8jwXEZhbQkli/8zgThC0vsXnNW7By
	CQF1iUd/dSEuMJI4tPYUI0SJiMS+F+8YJzAKzUIyaRaSSbOQTJqFpGUBI8sqRtHUguSC4qT0
	XEO94sTc4tK8dL3k/NxNjOD4fSa1g3Flg8UhRgEORiUeXocfiwOEWBPLiitzDzFKcDArifBG
	rV0SIMSbklhZlVqUH19UmpNafIjRB+jPicxSosn5wNSSVxJvaGxiZmRpZGZhZGJujkNYSZy3
	2SMlQEggPbEkNTs1tSC1CGYcEwenVAPjAn+Lj1MWB02IDCns+DLLfcLHw8zrNukdXxesKJ8d
	+ecdD6PJxAZ2xghlHTMOwbl5rkotPx52H5GJzLu7sHJ+Wl0bqwbHM7aUJt+jD6uFl+y8V8fg
	VDFPg7lXYoLZ7rAThU6bdsaq77d+vPzMcgGH59c4DoQ/Yi/bKKB+qnVdrs/b2hNv1ucqsRRn
	JBpqMRcVJwIAaO3rFQwDAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 15, 2012 3:52 PM Thierry Reding wrote
> On Thu, Nov 15, 2012 at 10:30:11AM +0900, Jingoo Han wrote:
> > On Friday, November 09, 2012 11:05 PM Thierry Reding wrote
> > >
> > > This function finds the struct backlight_device for a given device tree
> > > node. A dummy function is provided so that it safely compiles out if OF
> > > support is disabled.
> > >
> > > Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> >
> > CC'ed Andrew Morton
> 
> Yes, the backlight subsystem isn't very well maintained, so I should
> have added Andrew in the first place. Thanks.
> 
> >
> > Hi Thierry Reding,
> >
> > The patch itself looks good.
> > Could you explain when this API is used?
> > Thank you.
> 
> I use this for the upcoming Tegra DRM driver in order to hook up the
> backlight with the DRM driver via DT to allow switching off the
> backlight when the corresponding DRM output is switched of using DPMS.
> Basically what you have is something like this in the device tree:
> 
> 	display {
> 		...
> 
> 		backlight = <&backlight>;
> 
> 		...
> 	}
> 
> Then you call something along these lines:
> 
> 	np = of_parse_phandle(display, "backlight", 0);
> 	if (np) {
> 		backlight = of_find_backlight_by_node(np);
> 		of_node_put(np);
> 	}
> 
> And then use the standard backlight API on the returned pointer.

OK, I see how this API can be called.
AS you mentioned, it will allow Tegra DRM driver to use
the backlight driver.

Acked-by: Jingoo Han <jg1.han@samsung.com>


Best regards,
Jingoo Han

> 
> Thierry

