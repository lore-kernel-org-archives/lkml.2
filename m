Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750872Ab1E2EtN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 00:49:13 -0400
Received: from vms173001pub.verizon.net ([206.46.173.1]:55301 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764Ab1E2EtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 00:49:11 -0400
Date: Sun, 29 May 2011 00:48:52 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: James Bottomley <James.Bottomley@suse.de>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, mark gross <markgross@thegnar.org>,
        David Alan Gilbert <linux@treblig.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: [Patch v2] idle governor: Avoid lock acquisition to read pm_qos
 before entering idle
In-reply-to: <1297457344.2645.323.camel@schen9-DESK>
Message-id: <alpine.LFD.2.02.1105290048380.7577@arrandale.kernel.org>
References: <1297457344.2645.323.camel@schen9-DESK>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

applied

thanks,
Len Brown, Intel Open Source Technology Center

