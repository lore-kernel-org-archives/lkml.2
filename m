Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377Ab0KYQtx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 11:49:53 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:59835 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754332Ab0KYQtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 11:49:51 -0500
Date: Thu, 25 Nov 2010 17:49:24 +0100
From: Borislav Petkov <bp@amd64.org>
To: "Raoul Bhatia [IPAX]" <r.bhatia@ipax.at>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "trivial@kernel.org" <trivial@kernel.org>
Subject: Re: [PATCH] trivial: fix typos in Documentation/edac.txt
Message-ID: <20101125164923.GA32383@aftab>
References: <4CEA729A.2070300@ipax.at>
 <20101122144702.GA2704@kryptos.osrc.amd.com>
 <4CEE7FF0.4090605@ipax.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CEE7FF0.4090605@ipax.at>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 25, 2010 at 10:25:36AM -0500, Raoul Bhatia [IPAX] wrote:
> Fixing trivial typos in edac.txt.
> patch for linux-2.6.36.1.
> 
> Signed-off-by: Raoul Bhatia <r.bhatia@ipax.at>

Ok, this is on its way of getting better but I still couldn't apply the
patch and had to edit it by hand because it was garbled - maybe because
you're using the browser to send email:

user-agent: Mozilla/5.0 (X11; U; Linux x86_64; de-DE; rv:1.9.2.13pre) Gecko/20101113 Shredder/3.1.7pre

and it obviously fiddles with whitespace.

For the future, please take a look at <Documentation/email-clients.txt>
for a good mail client to use when sending patches to LKML and after
you've configured it, send the patch yourself first and try applying
the received copy on another kernel repo (not the one you've used for
creating the patch, of course; or create a new git branch and try
applying it there). If it applies fine, your patch sending process works
and you can send the patch now to LKML :)

Anyway, applied.
Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
