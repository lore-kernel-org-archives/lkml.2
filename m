Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932505Ab0LNXWP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 18:22:15 -0500
Received: from vms173019pub.verizon.net ([206.46.173.19]:50323 "EHLO
	vms173019pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932436Ab0LNXWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 18:22:13 -0500
Date: Tue, 14 Dec 2010 18:22:02 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jack Steiner <steiner@sgi.com>, hmh@hmh.eng.br, tony.luck@gmail.com,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        gbeshers@sgi.com
Subject: Re: [PATCH] - Mapping ACPI tables as CACHED
In-reply-to: <4D07F6A2.2030706@zytor.com>
Message-id: <alpine.LFD.2.00.1012141819580.25387@x980>
References: <20101214220932.GA1206@sgi.com> <4D07F6A2.2030706@zytor.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Why just x86-64?

the patch applies to all x86, 32 and 64-bit.
