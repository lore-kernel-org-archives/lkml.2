Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729Ab1KHBAl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 20:00:41 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54069 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751217Ab1KHBAk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 20:00:40 -0500
From: Thomas Renninger <trenn@suse.de>
To: lenb@kernel.org
Subject: Re: [PATCH -v2 0/4] ACPI: Re-factor and remove ./drivers/acpi/atomicio.[ch]
Date: Tue, 8 Nov 2011 02:00:36 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc5-5.99.12.5343e5f-desktop; KDE/4.4.4; x86_64; ; )
Cc: Myron Stowe <myron.stowe@redhat.com>, linux-acpi@vger.kernel.org,
        rjw@sisk.pl, ying.huang@intel.com, bhelgaas@google.com,
        linux-kernel@vger.kernel.org
References: <20111107232321.13472.52069.stgit@amt.stowe>
In-Reply-To: <20111107232321.13472.52069.stgit@amt.stowe>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201111080200.37577.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Len: If these could still make it into 3.2, that would allow
consideration of access width for APEI GAR structures
which are needed for some BIOSes in an easy way.

These would be the one or other small patch which shouldn't
be a big issue to add later, but without these it gets ugly...

Thanks,

   Thomas
