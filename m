Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759326Ab2CMSSJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 14:18:09 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52904 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758692Ab2CMSSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 14:18:08 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v3 2/2] regulator: add device tree support for max8997
To: Thomas Abraham <thomas.abraham@linaro.org>
Cc: linux-kernel@vger.kernel.org, k.lewandowsk@samsung.com,
        devicetree-discuss@lists.ozlabs.org, rob.herring@calxeda.com,
        kgene.kim@samsung.com, broonie@opensource.wolfsonmicro.com,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        dg77.kim@samsung.com, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, Rajendra Nayak <rnayak@ti.com>
In-Reply-To: <CAJuYYwRAXyU7d7qhGUX-=qWUJ0M1KB3XCGPOnUxToP=0XOhzqg@mail.gmail.com>
References: <1330000688-11226-1-git-send-email-thomas.abraham@linaro.org> <1330000688-11226-3-git-send-email-thomas.abraham@linaro.org> <20120313034306.16CF73E07E4@localhost> <CAJuYYwRAXyU7d7qhGUX-=qWUJ0M1KB3XCGPOnUxToP=0XOhzqg@mail.gmail.com>
Date: Tue, 13 Mar 2012 12:18:03 -0600
Message-Id: <20120313181803.B45073E053B@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Mar 2012 12:14:42 +0530, Thomas Abraham <thomas.abraham@linaro.org> wrote:
> On 13 March 2012 09:13, Grant Likely <grant.likely@secretlab.ca> wrote:
> > On Thu, 23 Feb 2012 18:08:08 +0530, Thomas Abraham <thomas.abraham@linaro.org> wrote:
> > Otherwise, the patch looks pretty good.  (although seeing the decode function
> > has got me thinking that we need a much better way of decoding the dt data).
> 
> The parsing function looks huge since there is lot of data to pick up
> from the dt node.

Oh, I understand that you have to do it this way; I just think the core code
should make it a lot easier.  :-)

g.
