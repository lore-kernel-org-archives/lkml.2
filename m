Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759218Ab0LODE4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 22:04:56 -0500
Received: from mail.lixom.net ([70.86.134.90]:36128 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759091Ab0LODEz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 22:04:55 -0500
Date: Tue, 14 Dec 2010 21:04:55 -0600
From: Olof Johansson <olof@lixom.net>
To: rklein <rklein@nvidia.com>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>, Andrew Chew <AChew@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] power: bq20z75: Update return value of CURRENT NOW
Message-ID: <20101215030455.GA17414@lixom.net>
References: <1292374885.8731.3.camel@rklein-linux2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292374885.8731.3.camel@rklein-linux2>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 14, 2010 at 05:01:25PM -0800, rklein wrote:
> The BQ20Z75 will return a negative value for current if the battery is
> discharging and a positive value if charging. This should always be
> exported
> as a positive number.
> 
> Signed-off-by: Rhyland Klein <rklein@nvidia.com>

Reviewed-by: Olof Johansson <olof@lixom.net>

-Olof
