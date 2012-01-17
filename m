Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751016Ab2AQFUO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 00:20:14 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:44963 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714Ab2AQFUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 00:20:12 -0500
MIME-Version: 1.0
In-Reply-To: <1326777393.13517.39.camel@minggr>
References: <20120109003255.GA6598@havoc.gtf.org> <CA+55aFwcBQSoWfqdT9CxV=GAr5ex0=RnqtBDFty+=_Lua2VXGw@mail.gmail.com>
 <4F12E57E.3090805@garzik.org> <1326676534.13517.3.camel@minggr>
 <1326691403.13517.21.camel@minggr> <CA+55aFzqECJjbtgyOXy_H1smh09SsfgrAuVY7hK2sC-xj1GZHg@mail.gmail.com>
 <CA+55aFy+1DWUaOMormPHy7hCJxNfdxmiAnj8W0gqNTbeogNN4w@mail.gmail.com>
 <CA+55aFxvUvWHbJvconcjPmDhUVcCRGxxA-iD+HEngRSt4iox5g@mail.gmail.com> <1326777393.13517.39.camel@minggr>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 16 Jan 2012 21:19:50 -0800
X-Google-Sender-Auth: _8PQbfCX8yvMG1D-HyosC5dar6Q
Message-ID: <CA+55aFzNpK0z2A8-0v2bLEX_Wma5f3tkeSVjAdwpkrW0=3V_Wg@mail.gmail.com>
Subject: Re: [git patches] libata updates for 3.3
To: Lin Ming <ming.m.lin@intel.com>
Cc: Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@linux-foundation.org>,
        linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 16, 2012 at 9:16 PM, Lin Ming <ming.m.lin@intel.com> wrote:
>
> But ata port async suspend was not enabled in above patch.
> So I think this is a regression.

Ok. Jeff? Should I take that patch directly, or will you take it?

                  Linus
