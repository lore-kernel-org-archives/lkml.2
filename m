Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568Ab0KBNNr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 09:13:47 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37926 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752375Ab0KBNNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 09:13:43 -0400
Date: Tue, 2 Nov 2010 09:13:49 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Thiago Farina <tfransosi@gmail.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Liam Girdwood <lrg@slimlogic.co.uk>,
        alsa-devel@alsa-project.org, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: Add initial WM8958 support
Message-ID: <20101102131348.GB21476@opensource.wolfsonmicro.com>
References: <1288635611-25560-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <AANLkTikzEdgUqVU0N=y7Vy+fnqKyskVp6p0zMpdYmenk@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikzEdgUqVU0N=y7Vy+fnqKyskVp6p0zMpdYmenk@mail.gmail.com>
X-Cookie: Never give an inch!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 01, 2010 at 11:52:04PM -0200, Thiago Farina wrote:
> On Mon, Nov 1, 2010 at 4:20 PM, Mark Brown

> > +enum wm8994_type {
> > +       WM8994 = 0,
> > +       WM8958 = 1,
> > +};

> Don't need to initialize with = 0 and with = 1. This is done by default.

There is no runtime cost to doing this and so where the values are
important I feel the clarity from documenting the actual values is
useful, it saves anyone having to figure out if they are what is
expected.
