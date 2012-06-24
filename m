Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639Ab2FXAce (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 20:32:34 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:39029 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752717Ab2FXAcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 20:32:32 -0400
X-Sasl-enc: 8t2uCfnQ9+CSmG7bXXgNdGm4j4jPoMTdrX6y35e4r01X 1340497951
Date: Sat, 23 Jun 2012 21:32:24 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: platform-driver-x86@vger.kernel.org,
        Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Joey Lee <jlee@novell.com>
Subject: Re: [PATCH 1/5] thinkpad_acpi: Drop pm_message_t arguments from
 suspend routines
Message-ID: <20120624003224.GA20885@khazad-dum.debian.net>
References: <201206172226.42729.rjw@sisk.pl>
 <201206172227.23591.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201206172227.23591.rjw@sisk.pl>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Jun 2012, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Multiple suspend routines in drivers/platform/x86/thinkpad_acpi.c
> use take pm_message_t arguments that aren't used by any of them.
> Make those routines take no arguments as that's what they should do.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Someday it might be necessary for some of these routines to differentiate S3
from suspend-to-disk, but I will introduce a parameter when that day comes.

Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
