Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898Ab0LUXoa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 18:44:30 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:17985 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308Ab0LUXo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 18:44:29 -0500
X-PGP-Universal: processed;
	by hqnvupgp02.nvidia.com on Tue, 21 Dec 2010 15:44:26 -0800
Subject: Re: [PATCH 1/1] power: bq20z75: Update return value of CURRENT NOW
From: rklein <rklein@nvidia.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Chew <AChew@nvidia.com>, Olof Johansson <olof@lixom.net>
In-Reply-To: <20101221232230.GA5417@oksana.dev.rtsoft.ru>
References: <1292374885.8731.3.camel@rklein-linux2>
	 <20101215030455.GA17414@lixom.net> <1292892862.12618.1.camel@rklein-linux2>
	 <20101221232230.GA5417@oksana.dev.rtsoft.ru>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 21 Dec 2010 15:41:15 -0800
Message-ID: <1292974875.23715.0.camel@rklein-linux2>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-12-21 at 15:22 -0800, Anton Vorontsov wrote:
> On Mon, Dec 20, 2010 at 04:54:22PM -0800, rklein wrote:
> > On Tue, 2010-12-14 at 19:04 -0800, Olof Johansson wrote:
> > > On Tue, Dec 14, 2010 at 05:01:25PM -0800, rklein wrote:
> > > > The BQ20Z75 will return a negative value for current if the battery is
> > > > discharging and a positive value if charging. This should always be
> > > > exported
> > > > as a positive number.
> > > >
> > > > Signed-off-by: Rhyland Klein <rklein@nvidia.com>
> > > 
> > > Reviewed-by: Olof Johansson <olof@lixom.net>
> > > 
> > > -Olof
> > 
> > Anton, is this patch ok to get put in?
> 
> I'm not sure. Probably not. Why would you think that the current
> should always be positive? For ds2760 it isn't, for example.
> If some driver assumes always positive current, I think it should
> be fixed instead.
> 
> If the battery is discharging, let it be negative. That's what
> happens on wires anyway. :-)
> 

That makes sense to me, I will propose the change to the sw that was
expecting the positive value.

-rhyland

