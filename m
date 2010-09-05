Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796Ab0IEHUj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 03:20:39 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43180 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728Ab0IEHUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 03:20:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=riIGUGqg+Z/HIAsJKHSCrJJLbGVOn6JBsjjdvqxDy7j9mp1T9Z/ptmMpYDsuRe7KUq
         gGF6jLJcTIuK8+dDF1q8bhq42ZZjinWWHOr6VxgjFi1gVxVkXJ2lhXgX9J/G0B9GaZ5x
         c4yrziWz0dYU5Hk9PT01DDrUy3Qy/wmdEEgFA=
Date: Sun, 5 Sep 2010 09:20:41 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Christian Riesch <christian.riesch@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: [PATCH 0/2] [RFC] posix clock tuning
Message-ID: <20100905072041.GA2928@riccoc20.at.omicron.at>
References: <cover.1283504065.git.richard.cochran@omicron.at>
 <alpine.DEB.2.00.1009041221240.888@router.home>
 <4C828652.4060804@gmail.com>
 <alpine.DEB.2.00.1009042042130.9425@router.home>
 <20100905062240.GB2699@riccoc20.at.omicron.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100905062240.GB2699@riccoc20.at.omicron.at>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 05, 2010 at 08:22:40AM +0200, Richard Cochran wrote:
> At this point, I think it is clear that, in order to support IEEE
> 1588, some kind of changes are needed. I have argued and discussed the

Just to be absolutely clear, I should have said, "hardare clocks for
IEEE 1588." The aim of the patch set is to support a new kind of
hardware.

> Having said that, if you are convinced that the existing interfaces
> are good enough to support PTP (and possible future methods, as

Again, I meant "PTP hardware clocks."

When I get some more time, I'll try to put together an executive
summary of PTP and of all the discussions that have taken place over
the last few months on linux-netdev and the lkml.

Richard

