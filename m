Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758360Ab1FQMSu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 08:18:50 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47198 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758059Ab1FQMSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 08:18:48 -0400
Date: Fri, 17 Jun 2011 13:18:45 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, grant@secretlab.ca, ralf@linux-mips.org
Subject: Re: [PATCH] FRV: Hook up gpiolib support
Message-ID: <20110617121845.GA18493@opensource.wolfsonmicro.com>
References: <20110616102209.GC5262@opensource.wolfsonmicro.com>
 <20110615144823.GA2806@opensource.wolfsonmicro.com>
 <1306921767-31115-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <5194.1308074912@redhat.com>
 <19624.1308206191@redhat.com>
 <28714.1308307859@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28714.1308307859@redhat.com>
X-Cookie: Caution: Keep out of reach of children.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 17, 2011 at 11:50:59AM +0100, David Howells wrote:
> Okay:

Thanks, this is a lot more constructive.  I'm now wondering how anyone
has managed to use this header (which isn't exactly new or only used on
obscure architectures) without noticing and fixing this.

It's unlikely that I'm going to have the bandwidth to work on the cross
tree issues that sorting this would create in the immediate future, my
interest here is in stopping people bugging me about architectures that
don't keep up with the standard GPIO interface but it'd be good if
someone could do so.
