Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382Ab2AJHxP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 02:53:15 -0500
Received: from mga05.intel.com ([192.55.52.89]:5709 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751379Ab2AJHxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 02:53:13 -0500
MIME-Version: 1.0
In-Reply-To: <20120109111702.GE3644@mwanda>
References: <20111124114734.GB32522@elgon.mountain>
	<20120109111702.GE3644@mwanda>
Date: Mon, 9 Jan 2012 23:53:11 -0800
Message-ID: <CABE8wwuGk=Nf1YTPjM6yXgigoRhXPX1a1K7ZySREQoUyC4F8xg@mail.gmail.com>
Subject: Re: [patch] dmatest: store correct thread count in dmatest_add_channel()
From: Dan Williams <dan.j.williams@intel.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 9, 2012 at 3:17 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> Ping?
>
> regards,
> dan carpenter

Just a comedy of delay, on my part, in getting this patch merged.  In
fact there is this fix that pre-dates yours:

  http://marc.info/?l=linux-kernel&m=131388785009475&w=2

I'll push this along.

Thanks for the nudge,
Dan
