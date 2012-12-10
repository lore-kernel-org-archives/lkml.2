Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281Ab2LJNrX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 08:47:23 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:35555 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751498Ab2LJNrW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 08:47:22 -0500
Message-ID: <1355147242.26815.9.camel@joe-AO722>
Subject: Re: [PATCH 5/5] rtl8712: replace leading spaces with tab
From: Joe Perches <joe@perches.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: devel@driverdev.osuosl.org, florian.c.schilhabel@googlemail.com,
        Przemo Firszt <przemo@firszt.eu>, linux-kernel@vger.kernel.org,
        Larry.Finger@lwfinger.net
Date: Mon, 10 Dec 2012 05:47:22 -0800
In-Reply-To: <20121210122103.GT6568@mwanda>
References: <1355048110-10859-1-git-send-email-przemo@firszt.eu>
	 <1355048110-10859-5-git-send-email-przemo@firszt.eu>
	 <20121210094613.GR6568@mwanda> <1355140186.26815.6.camel@joe-AO722>
	 <20121210122103.GT6568@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-12-10 at 15:21 +0300, Dan Carpenter wrote:
> On Mon, Dec 10, 2012 at 03:49:46AM -0800, Joe Perches wrote:
> > checkpatch parenthesis alignment of arguments checks are
> > emitted only when adding --strict to the command line.
> Even with --strict checkpatch.pl is fine with the original code.

Right. I just checked.
Parenthesis alignment is only done for

	if (

It might be tricky to do it correctly
for other cases.

