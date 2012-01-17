Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645Ab2AQJYr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 04:24:47 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:60013 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340Ab2AQJYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 04:24:42 -0500
Message-ID: <4F153E53.6020108@kernel.org>
Date: Tue, 17 Jan 2012 04:24:35 -0500
From: Len Brown <lenb@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110906 Fedora/3.1.14-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.14
MIME-Version: 1.0
To: Kurt Garloff <kurt@garloff.de>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, "Luck, Tony" <tony.luck@intel.com>,
        x86@vger.kernel.org
Subject: Re: [PATCH 1/3]: Store SRAT revision
References: <20120115213005.GT12380@tpkurt2.garloff.de> <20120115213407.GU12380@tpkurt2.garloff.de>
In-Reply-To: <20120115213407.GU12380@tpkurt2.garloff.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

looks fine to me.
as #2 (x86) and #3 (ia64) depend on #1, which is ACPI,
I can send this via the ACPI tree.

thanks,
-Len Brown, Intel Open Source Technology Center
