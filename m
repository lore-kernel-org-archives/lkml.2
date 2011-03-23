Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170Ab1CWEIv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 00:08:51 -0400
Received: from vms173003pub.verizon.net ([206.46.173.3]:54043 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947Ab1CWEIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 00:08:49 -0400
Date: Wed, 23 Mar 2011 00:08:44 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 1/4] X86: Revamp reboot behaviour to match Windows more
 closely
In-reply-to: <1299877940-6870-1-git-send-email-mjg@redhat.com>
Message-id: <alpine.LFD.2.02.1103230003310.10549@x980>
References: <1299877940-6870-1-git-send-email-mjg@redhat.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Mar 2011, Matthew Garrett wrote:

> Windows reboots by hitting the ACPI reboot vector (if available), trying
> the keyboard controller, hitting the ACPI reboot vector again and then
> giving the keyboard controller one last go. Rework our reboot process a
> little to default to matching this behaviour, although we'll fall through
> to attempting a triple fault if nothing else works.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>

Acked-by: Len Brown <len.brown@intel.com>

This looks like "tip" material.

thanks,
Len Brown, Intel Open Source Technology Center
