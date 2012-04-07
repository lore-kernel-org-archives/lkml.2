Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757691Ab2DGBwI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 21:52:08 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:52095 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755244Ab2DGBwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 21:52:01 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 1/2] arm/dts: omap4-sdp: Add keypad data
To: "Cousson, Benoit" <b-cousson@ti.com>, Sourav Poddar <sourav.poddar@ti.com>
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, Felipe Balbi <balbi@ti.com>,
        linux-input@vger.kernel.org, linux-arm-kernel@lists.infradead.org
In-Reply-To: <4F7C51EA.1040902@ti.com>
References: <1333546221-19700-1-git-send-email-sourav.poddar@ti.com> <1333546221-19700-2-git-send-email-sourav.poddar@ti.com> <4F7C51EA.1040902@ti.com>
Date: Fri, 06 Apr 2012 18:39:27 -0700
Message-Id: <20120407013927.AC7163E21DC@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Apr 2012 15:51:38 +0200, "Cousson, Benoit" <b-cousson@ti.com> wrote:
> On 4/4/2012 3:30 PM, Sourav Poddar wrote:
> > This patch add keypad data node in omap4 device tree
> > file.
> 
> Nit #2: Never write "this patch" in a patch changelog... Because at some 
> point it will become a commit in a GIT tree.
> 
> I think AKPM wrote something on that.

Whatever.  I'm won't *ever* get worked up about something like that if
the changelog is otherwise well written.  What I do want to see is a
description of what the patch does, why it is needed, and how it was
tested.

g.

