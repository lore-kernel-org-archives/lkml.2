Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760293Ab0LOEDq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 23:03:46 -0500
Received: from vms173003pub.verizon.net ([206.46.173.3]:53068 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759208Ab0LOEDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 23:03:45 -0500
Date: Tue, 14 Dec 2010 23:03:38 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Jack Steiner <steiner@sgi.com>
Cc: hpa@zytor.com, hmh@hmh.eng.br, tony.luck@gmail.com,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        gbeshers@sgi.com
Subject: Re: [PATCH] - Mapping ACPI tables as CACHED
In-reply-to: <20101215024136.GB19601@sgi.com>
Message-id: <alpine.LFD.2.00.1012142302110.4878@x980>
References: <20101214220932.GA1206@sgi.com>
 <alpine.LFD.2.00.1012141903210.25387@x980> <20101215024136.GB19601@sgi.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-       free_initmem();
+//     free_initmem();

allows this patch to boot, so the problem is with use of code and 
data marked __init.

thanks,
Len Brown, Intel Open Source Technology Center

