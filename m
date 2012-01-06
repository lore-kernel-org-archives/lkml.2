Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758514Ab2AFCLo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 21:11:44 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43710 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757278Ab2AFCLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 21:11:42 -0500
Date: Fri, 6 Jan 2012 06:11:37 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: Ashish Jangam <ashish.jangam@kpitcummins.com>, linaro-dev@lists.linaro.org,
        sameo@linux.intel.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Dajun <dajun.chen@diasemi.com>,
        dwmw2@infradead.org
Subject: Re: [PATCH 05/06] Power: DA9052 Battery module V6
Message-ID: <20120106021137.GB21540@oksana.dev.rtsoft.ru>
References: <1323865676.32031.24.camel@dhruva>
 <CAOMZO5BuJbn9G2p6tZopmTGYarjmLSCTSKXAYN+aoUQjQ-mAiw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOMZO5BuJbn9G2p6tZopmTGYarjmLSCTSKXAYN+aoUQjQ-mAiw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 11:16:57AM -0200, Fabio Estevam wrote:
> On Wed, Dec 14, 2011 at 10:27 AM, Ashish Jangam
> <ashish.jangam@kpitcummins.com> wrote:
> 
> > +static u32 const vc_tbl[3][68][2] = {
> > +       /* For temperature 10 degree celisus*/
> 
> s/celisus/Celsius
> 
> Same on other places.

I fixed this and applied the patch.

Thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
