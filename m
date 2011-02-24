Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756614Ab1BXXZA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 18:25:00 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:60899 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756527Ab1BXXY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 18:24:58 -0500
X-Authority-Analysis: v=1.1 cv=3uSaImBeuprzHBlOOPjkqgu+7PcxSRW0m2Aphm9Zmck= c=1 sm=0 a=inHTpO_ulcMA:10 a=kj9zAlcOel0A:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=ilvd3-_EowockOxowN0A:9 a=m5peLU_MgHo21jpE5zrn_ewuwrwA:4 a=CjuIK1q_8ugA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Date: Thu, 24 Feb 2011 18:24:56 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Glauber Costa <glommer@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] expose kvmclock upper msr set.
Message-ID: <20110224232456.GG888@home.goodmis.org>
References: <1298483054-1665-1-git-send-email-glommer@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298483054-1665-1-git-send-email-glommer@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 12:44:14PM -0500, Glauber Costa wrote:
> We've been supporting kvmclock MSRs in the 0x4b564d00-0x4b564dff range
> for a while now, but we're not exposing it yet, meaning nobody is using it.
> This simple patch takes care of that.

Is nobody using it because it was never exposed? Or because nobody ever
needed it, and we don't care (thus don't bother supporting it).

-- Steve

