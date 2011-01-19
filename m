Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844Ab1ASJTY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 04:19:24 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55238 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752736Ab1ASJTX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 04:19:23 -0500
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: "Jan Beulich" <JBeulich@novell.com>
Subject: Re: [PATCH, resend] x86: unify "numa=" command line option handling
Date: Wed, 19 Jan 2011 10:19:21 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-8.99.14.138eeaa-desktop; KDE/4.5.95; x86_64; ; )
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
        "Tejun Heo" <tj@kernel.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <4D36B581020000780002D0FF@vpn.id2.novell.com>
In-Reply-To: <4D36B581020000780002D0FF@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101191019.21299.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, January 19, 2011 09:57:21 AM Jan Beulich wrote:
> In order to be able to suppress the use of SRAT tables that 32-bit
> Linux can't deal with (in one case known to lead to a non-bootable
> system, unless disabling ACPI altogether), move the "numa=" option
> handling to common code.
As this does not only unify the numa_32/64.c code a bit, but is
also needed for being able to boot a machine, it looks like a
candidate for 2.6.38-rcX.

Reviewed-by: Thomas Renninger <trenn@suse.de>

    Thomas
