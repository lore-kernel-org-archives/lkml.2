Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933133Ab0HEIYY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 04:24:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50522 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759845Ab0HEIYW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 04:24:22 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Huang Ying <ying.huang@intel.com>
Subject: Re: [PATCH 4/4] ACPI, APEI, ERST debug support
Date: Thu, 5 Aug 2010 10:27:37 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.31.5-0.1-desktop; KDE/4.4.3; x86_64; ; )
Cc: Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, linux-acpi@vger.kernel.org
References: <1280735305-15379-1-git-send-email-ying.huang@intel.com> <1280735305-15379-5-git-send-email-ying.huang@intel.com>
In-Reply-To: <1280735305-15379-5-git-send-email-ying.huang@intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201008051027.37573.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 August 2010 09:48:25 Huang Ying wrote:
> This patch adds debugging/testing support to ERST. A misc device is
> implemented to export raw ERST read/write/clear etc operations to user
> space. With this patch, we can add ERST testing support to
> linuxfirmwarekit ISO (linuxfirmwarekit.org) to verify the kernel
> support and the firmware implementation.

Shouldn't this show up in debugfs?

      Thomas
