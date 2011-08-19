Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543Ab1HSQvA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 12:51:00 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:43847 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932066Ab1HSQuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 12:50:55 -0400
Date: Fri, 19 Aug 2011 20:50:51 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: Philip Rakity <prakity@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?utf-8?B?67CV6rK966+8?= <kyungmin.park@samsung.com>
Subject: Re: [PATCH] power: max17042: do not lose accuracy calculating
 current_now
Message-ID: <20110819165051.GI22761@oksana.dev.rtsoft.ru>
References: <26076760.93301313475177035.JavaMail.weblogic@epml13>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <26076760.93301313475177035.JavaMail.weblogic@epml13>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 16, 2011 at 06:12:58AM +0000, MyungJoo Ham wrote:
> Philip Rakity<prakity@marvell.com> Date : 2011-08-13 13:19 (GMT+09:00)
> > 
> > PROP_CURRENT_NOW value is first divided then multiplied up
> > causing a lose of accuracy.  Use the same method as
> > PROP_CURRENT_AVG to do the calculation.
> > 
> > Signed-off-by: Philip Rakity 
> 
> Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>

Applied, thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
