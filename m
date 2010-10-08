Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756368Ab0JHQaX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 12:30:23 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40670 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752427Ab0JHQaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 12:30:22 -0400
Date: Fri, 8 Oct 2010 09:30:34 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jeffrey Carlyle <jeff.carlyle@motorola.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
        Lun Chang <w13550@motorola.com>
Subject: Re: [PATCH 1/3] regulator: Add notifier event on regulator disable
Message-ID: <20101008163033.GA5092@opensource.wolfsonmicro.com>
References: <20100104181634.GA18258@rakim.wolfsonmicro.main>
 <1262629066-18398-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <AANLkTimWPZJzp61uCNMcu1o8Nra4_FQyUhjrtox2sxB2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimWPZJzp61uCNMcu1o8Nra4_FQyUhjrtox2sxB2@mail.gmail.com>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 08:27:10AM -0500, Jeffrey Carlyle wrote:

> Am I doing something wrong in how I am setting up B as the supply for
> A or is this bug in the regulator core code?

Nothing in mainline chains regulators so this will just have bitrotted.
