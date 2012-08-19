Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345Ab2HSKgF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 06:36:05 -0400
Received: from canardo.mork.no ([148.122.252.1]:49733 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751357Ab2HSKgC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 06:36:02 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Huang Ying <ying.huang@intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-pm@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 0/4] PCI/PM: PCI D3cold support fixes for 3.6-rc1
Organization: m
References: <1343975435-25469-1-git-send-email-ying.huang@intel.com>
Date: Sun, 19 Aug 2012 12:35:53 +0200
In-Reply-To: <1343975435-25469-1-git-send-email-ying.huang@intel.com> (Huang
	Ying's message of "Fri, 3 Aug 2012 14:30:31 +0800")
Message-ID: <87393jmanq.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang Ying <ying.huang@intel.com> writes:

> [BUGFIX 1/4] PCI/PM: enable D3/D3cold by default for most devices
> [BUGFIX 2/4] PCI/PM: Keep parent bridge active when probing device
> [BUGFIX 3/4] PCI/PM: Fix config reg access for D3cold and bridge suspending
> [PATCH 4/4] PCI/PM: Add ABI document for sysfs file d3cold_allowed

Hello,

I am hoping these patches will appear in 3.6?  They fix real problems in
3.6-rc1 for me. If it helps in any way, feel free to add

Tested-by: Bjørn Mork <bjorn@mork.no>

to the 3 bugfix patches, including version 2 of patch #3.


Bjørn
