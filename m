Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756664Ab0LOAEW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 19:04:22 -0500
Received: from vms173001pub.verizon.net ([206.46.173.1]:44345 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542Ab0LOAEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 19:04:21 -0500
Date: Tue, 14 Dec 2010 19:04:13 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Jack Steiner <steiner@sgi.com>
Cc: hpa@zytor.com, hmh@hmh.eng.br, tony.luck@gmail.com,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        gbeshers@sgi.com
Subject: Re: [PATCH] - Mapping ACPI tables as CACHED
In-reply-to: <20101214220932.GA1206@sgi.com>
Message-id: <alpine.LFD.2.00.1012141903210.25387@x980>
References: <20101214220932.GA1206@sgi.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hmm, my arrandale laptop fails to get into graphics mode w/ this patch 
applied -- last thing i see is the kernel freeing memory, then black 
screen.

thanks,
Len Brown, Intel Open Source Technology Center

