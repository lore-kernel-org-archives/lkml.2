Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025Ab2AQNUY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 08:20:24 -0500
Received: from cc-smtpout3.netcologne.de ([89.1.8.213]:40750 "EHLO
	cc-smtpout3.netcologne.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487Ab2AQNUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 08:20:23 -0500
X-AuthUser: garloff@garloff.de
References: <20120115213005.GT12380@tpkurt2.garloff.de> <20120115213407.GU12380@tpkurt2.garloff.de> <4F153E53.6020108@kernel.org>
User-Agent: K-9 Mail for Android
In-Reply-To: <4F153E53.6020108@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/3]: Store SRAT revision
From: Kurt Garloff <kurt@garloff.de>
Date: Tue, 17 Jan 2012 14:20:11 +0100
To: Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, "Luck, Tony" <tony.luck@intel.com>,
        x86@vger.kernel.org
Message-ID: <2cf343f2-24d6-4912-b4fe-121956cdd612@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Len,



Len Brown <lenb@kernel.org> schrieb:

> looks fine to me.
> as #2 (x86) and #3 (ia64) depend on #1, which is ACPI,
> I can send this via the ACPI tree.

Thanks for reviewing this!
I'll wait for the git commits then and resubmit to stable (forgot to add a Cc line in the signed-off section, as GKH thankfully pointed out).

Thx,
-- 
Kurt Garloff <kurt@garloff.de>  [Köln/Greven]
(Sent from Android phone with K-9 Mail.)
