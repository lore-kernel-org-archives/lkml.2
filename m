Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933043Ab0E0FO1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 01:14:27 -0400
Received: from vms173019pub.verizon.net ([206.46.173.19]:60936 "EHLO
	vms173019pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932190Ab0E0FO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 01:14:26 -0400
Date: Thu, 27 May 2010 01:14:21 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warnings after merge of the acpi tree
In-reply-to: <20100527144111.84b2e651.sfr@canb.auug.org.au>
Message-id: <alpine.LFD.2.00.1005270113170.4039@localhost.localdomain>
References: <20100527144111.84b2e651.sfr@canb.auug.org.au>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> drivers/idle/intel_idle.c:324: warning: unused variable 'cstate'

fixed in the latest version.

thanks,
Len Brown, Intel Open Source Technology Center
