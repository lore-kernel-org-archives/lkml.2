Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752963Ab1A1ABD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 19:01:03 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36672 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751487Ab1A1ABB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 19:01:01 -0500
Date: Thu, 27 Jan 2011 16:00:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ben Dooks <ben@simtec.co.uk>
Cc: Jack Stone <jwjstone@fastmail.fm>, Ben Dooks <ben-linux@fluff.org>,
        Vincent Sanders <vince@simtec.co.uk>,
        Simtec Support <support@simtec.co.uk>, linux-kernel@vger.kernel.org,
        linux@simtec.co.uk
Subject: Re: [PATCH 3/3] MAINTAINERS: Fixup Simtec support email entries
Message-Id: <20110127160034.b3aab078.akpm@linux-foundation.org>
In-Reply-To: <4D302727.6070006@simtec.co.uk>
References: <0bd9310fc4d79ee83f9f657640be251d84dbf86f.1294998254.git.ben-linux@fluff.org>
	<fd0227dd223f5c88e559b2902d5124107ffb7c6a.1294998254.git.ben-linux@fluff.org>
	<4D302081.3020102@fastmail.fm>
	<4D302727.6070006@simtec.co.uk>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Jan 2011 10:36:23 +0000
Ben Dooks <ben@simtec.co.uk> wrote:

> On 14/01/11 10:08, Jack Stone wrote:
> > On 14/01/2011 09:44, Ben Dooks wrote:
> >> The support@simtec.co.uk address is for direct customer support only, the
> >> EB2410ITX and EB110ATX entries should direct to the Simtec Linux Team
> >> address of linux@simtec.co.uk
> >>
> >> Also add correct email address for Vincent Sanders
> >>
> >> Signed-off-by: Ben Dooks <ben-linux@fluff.org>
> >> Cc: Vincent Sanders <vince@simtec.co.uk>
> >> Cc: Simtec Support <support@simtec.co.uk>
> >> Cc: Simtec Linux Team <linux@simtec.co.uk>
> >> ---
> >>  MAINTAINERS |    6 ++++--
> >>  1 files changed, 4 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/MAINTAINERS b/MAINTAINERS
> >> index 4a99ddf..3f5dc25 100644
> >> --- a/MAINTAINERS
> >> +++ b/MAINTAINERS
> >> @@ -5557,13 +5557,15 @@ F:	include/linux/sfi*.h
> >>  
> >>  SIMTEC EB110ATX (Chalice CATS)
> >>  P:	Ben Dooks
> >> -M:	Vincent Sanders <support@simtec.co.uk>
> >> +P:	Vincent Sanders <support@simtec.co.uk>
> > 
> > Did you mean to update this email as well?
> 
> Thankyou, will correct this.
> 

<ETIMEDOUT>

Like this?

--- a/MAINTAINERS~maintainers-fixup-simtec-support-email-entries-fix
+++ a/MAINTAINERS
@@ -5622,7 +5622,7 @@ F:	include/linux/sfi*.h
 
 SIMTEC EB110ATX (Chalice CATS)
 P:	Ben Dooks
-P:	Vincent Sanders <support@simtec.co.uk>
+P:	Vincent Sanders <vince@simtec.co.uk>
 M:	Simtec Linux Team <linux@simtec.co.uk>
 W:	http://www.simtec.co.uk/products/EB110ATX/
 S:	Supported
_

