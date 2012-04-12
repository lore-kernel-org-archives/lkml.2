Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965478Ab2DLPqz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 11:46:55 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55488 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756677Ab2DLPqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 11:46:54 -0400
Date: Thu, 12 Apr 2012 16:46:50 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: mainline build failure (Was: Re: linux-next: build failure after
 merge of the regmap tree)
Message-ID: <20120412154649.GA3195@opensource.wolfsonmicro.com>
References: <20120411141346.3c4dd8e481d052b583ac95b6@canb.auug.org.au>
 <20120411081711.GB3163@opensource.wolfsonmicro.com>
 <20120412080714.1b9fe574b18adebcc8af0ff1@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XsQoSWH+UP9D9v3l"
Content-Disposition: inline
In-Reply-To: <20120412080714.1b9fe574b18adebcc8af0ff1@canb.auug.org.au>
X-Cookie: Never give an inch!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 12, 2012 at 08:07:14AM +1000, Stephen Rothwell wrote:

> So, what is this failure and what configs do you build?  And has a fix
> been submitted?

It's a build failure in the trace subsystem when perf isn't enabled; I
submitted a patch as soon as I noticed the issue which was either during
the merge window or just after -rc1 came out and resubmitted it again
this week.  In response to the reposting Steven Rostedt said he'd pick
the fix up but I'm not sure when that'll happen or how long it'll take
to propagate to mainline, this appears to be one of those areas where
things get processed in batch mode.

I mainly build an ARM config that I can run usefully on my development
boards which is mostly built in and a modular x86 config since x86 seems
to have lots of issues with modular stuff.  I should be able to adjust
the ARM config to build, I didn't yet mostly because I wasn't expecting
the issue to be ignored for so long.

--XsQoSWH+UP9D9v3l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPhvilAAoJEBus8iNuMP3dXV8P/AnGkqfNAAa518rqX/cYxpLK
y33EA5J2MrkvzTdtj18nBxKSEr5ZsH6S9TE9Q4BLjHP72DiW9bOkwDd3aAYu/he1
L/ZzX/whiwXKFdsCNbT+BdI0fTNXpDfYQQ7CJGHdop10NgjpBn63QTmdvjt0J8eE
Ex9Ug4uLNgpSlqoXChIzJ3vdGiCrQhLUNkZ/dzLuQRFQxfmnM70u8lO7XqX9027f
V26vO896LfyyeFXSqPw8MqPQrQIV/ptcpJBst9Bfq3Al1xIeTQAlf9zrg4MQI5yS
q+sgmwb9tbu19Ri8sEjbx5gUg5Y8tRjH6LqQgJBSHTPBhe/KX3bzsIhY6AvkJQis
VdMTzj1qm03gF/TnAChAWQLmtxOyo4jeNDOQ31Y+F7uYpV4lms3zffibyvsl0GFi
sqz0FIYNjZA/F0YNjiIqZnL3nIWsYDYQgq13naZxOWaLEsZJRMRo2XAaZ4jD8pCr
7xfIogNnBlTJ7FQtq674037gDaUBBR9orJqFatiQ0AlTqk5Z7xQzmgQWxdsHWrc5
xoAk96LSgAdtY5/ybgKqiiQcOv62O2TJnaFl0iZcrlRNhL745LQl8ZBryyU46inj
25Svc+rwWZnJQ6V3PhZng0zc9KmPZHLrNAudfxWLty6GWl1OD7IRGhT8yr9xP3FH
4OLl27HdCPa100VcTbWy
=ls7p
-----END PGP SIGNATURE-----

--XsQoSWH+UP9D9v3l--
