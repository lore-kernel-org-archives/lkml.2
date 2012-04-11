Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759601Ab2DKLmW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 07:42:22 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:37491 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758781Ab2DKLmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 07:42:20 -0400
X-Sasl-enc: 9nI7eAvpnX88bWCmQvuyz5TvFPCpNJgQvSQjiE1bBz/e 1334144538
Date: Wed, 11 Apr 2012 08:42:11 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Alex Hung <alex.hung@canonical.com>
Cc: ibm-acpi@hmh.eng.br, mjg@redhat.com, ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] thinkpad_acpi: added BIOS mute interfaces for volume
Message-ID: <20120411114211.GA11445@khazad-dum.debian.net>
References: <1334139302-7152-1-git-send-email-alex.hung@canonical.com>
 <4F855A2B.6070402@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F855A2B.6070402@canonical.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Apr 2012, Alex Hung wrote:
> I am modifying thinkpad_acpi so it can support the mute led, and I
> am looking for suggestions and feedbacks.
> 
> For newer BIOS, it includes three aml methods that can be used to
> get, set and enable the mute led.

Aha!  THANK YOU.

I will look at the patches this week.  Please send me (directly) a full
dmidecode and ACPI table dump.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
