Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757238Ab0E0CgJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 22:36:09 -0400
Received: from vms173019pub.verizon.net ([206.46.173.19]:33766 "EHLO
	vms173019pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755093Ab0E0CgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 22:36:07 -0400
Date: Wed, 26 May 2010 22:35:52 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linux Power Management List <linux-pm@lists.osdl.org>,
       linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: please pull "idle-test" branch into linux-next
Message-id: <alpine.LFD.2.00.1005262231570.4039@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

The idle patches currently in linux-acpi are unrelated to ACPI,
so I'm moving them to a new home.  Please add the new home
to your linux-next pull list:

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-idle-2.6.git idle-test

thanks,
Len Brown, Intel Open Source Technology Center
