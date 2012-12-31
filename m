Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319Ab2LaBpU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2012 20:45:20 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:56489 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755280Ab2LaBpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2012 20:45:17 -0500
X-Sasl-enc: SascGgGP6GGe0OVedOm+G1G6/ru5kzh7R4LFgFSKQfVf 1356918316
Date: Sun, 30 Dec 2012 23:45:13 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Richard Hartmann <richih.mailinglist@gmail.com>
Cc: ibm-acpi-devel@lists.sourceforge.net, ibm-acpi@hmh.eng.br,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        platform-driver-x86@vger.kernel.org
Subject: Re: [ibm-acpi-devel] [PATCH] drivers/platform/x86/thinkpad_acpi.c:
 Handle HKEY event 0x6040
Message-ID: <20121231014513.GA2416@khazad-dum.debian.net>
References: <CAD77+gROUfVX=9LPZc6_jf=2Bc_iaf5FW5Z2efwESzORNrq9dQ@mail.gmail.com>
 <1356817910-20890-1-git-send-email-richih.mailinglist@gmail.com>
 <20121230020008.GA24121@khazad-dum.debian.net>
 <CAD77+gROHKXOBDAy8A4sLnzSnZXTz-KKomk4nqrEfapjNo03vA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD77+gROHKXOBDAy8A4sLnzSnZXTz-KKomk4nqrEfapjNo03vA@mail.gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 30 Dec 2012, Richard Hartmann wrote:
> On Sun, Dec 30, 2012 at 3:00 AM, Henrique de Moraes Holschuh <hmh@hmh.eng.br
> > wrote:
> 
> > Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> >
> 
> Thanks for the two ACKs.
> 
> Just to make sure: From how I read the (outdated) Copyright section, you
> are the maintainer of thinkpad_acpi and thus will copy over the ACKs into
> my commit message, merge, and forward into what will become 3.9 at some
> point, correct?

Usually the subsystem maintainer picks such simple patches and ACKs directly
from the platform-driver-x86 list email, adds his signed-of-by, and
eventually sends it to Linus.

For this "obviously correct" single-code-line fix, we might even lucky
out and it could make it to 3.8, depends on his judgment.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
