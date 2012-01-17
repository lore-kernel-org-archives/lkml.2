Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338Ab2AQOIf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 09:08:35 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:52905 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753763Ab2AQOId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 09:08:33 -0500
Message-ID: <4F1580DE.1060002@kernel.org>
Date: Tue, 17 Jan 2012 09:08:30 -0500
From: Len Brown <lenb@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110906 Fedora/3.1.14-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.14
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad@darnok.org>
CC: "H. Peter Anvin" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        "Brown, Len" <len.brown@intel.com>, linux-acpi@vger.kernel.org,
        sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, pjones@redhat.com
Subject: Re: Re-add ibft tree to linux-next please
References: <20111212145330.GA16278@andromeda.dapyr.net> <4EE68D57.7030603@zytor.com> <20111213021536.GC2730@konrad-lan>
In-Reply-To: <20111213021536.GC2730@konrad-lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> The trick is that we also have to retain the code functionality if
> "# CONFIG_ACPI is not set" to scan the memory for the iBFT. That part
> should definitly _not_ be moved to drivers/acpi. It could be moved to
> arch/x86/ .. but it could also stay in drivers/firmware. <shrugs>


Are there really hardware/firmware configurations that support IBFT
and do not support ACPI?

If yes, do they require an OS that has CONFIG_ACPI=n?
Or would finding the table with CONFIG_ACPI=y and acpi_disabled=1
be sufficient?

-Len

