Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657Ab1CCMEW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 07:04:22 -0500
Received: from mga09.intel.com ([134.134.136.24]:38021 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751906Ab1CCMEV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 07:04:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,258,1297065600"; 
   d="scan'208";a="608613742"
Date: Thu, 3 Mar 2011 11:43:06 +0000
From: Alan Cox <alan@linux.intel.com>
To: Len Brown <lenb@kernel.org>
Cc: Matthew Garrett <mjg@redhat.com>, linux-acpi@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] staging: Use generic IGD opregion code for gma500
Message-ID: <20110303114306.31114533@bob.linux.org.uk>
In-Reply-To: <alpine.LFD.2.02.1103022114250.12344@x980>
References: <1298404994-2907-1-git-send-email-mjg@redhat.com>
	<1298404994-2907-2-git-send-email-mjg@redhat.com>
	<alpine.LFD.2.02.1103022114250.12344@x980>
Organization: Intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 02 Mar 2011 21:14:31 -0500 (EST)
Len Brown <lenb@kernel.org> wrote:

> applied to acpi-test

NAK this - with it applied the GMA500 driver oopses in the opregion code

