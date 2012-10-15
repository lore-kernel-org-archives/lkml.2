Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751557Ab2JOIfP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 04:35:15 -0400
Received: from smtp2.infineon.com ([217.10.60.23]:41724 "EHLO
	smtp2.infineon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237Ab2JOIfN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 04:35:13 -0400
X-SBRS: None
From: <Peter.Huewe@infineon.com>
To: <jgunthorpe@obsidianresearch.com>, <key@linux.vnet.ibm.com>
CC: <tpmdd-devel@lists.sourceforge.net>, <linux-kernel@vger.kernel.org>
Subject: RE: [tpmdd-devel] [PATCH] TPM: Let the tpm char device be openable
	multiple times
Thread-Topic: [tpmdd-devel] [PATCH] TPM: Let the tpm char device be openable
	multiple times
Thread-Index: AQHNn2Y1yFzAZfQ3OkOolIErIs1buZeyqZsAgANuTgCABAh+sA==
Date: Mon, 15 Oct 2012 08:35:09 +0000
Message-ID: <74A44E99E3274B4CB570415926B37D440ED140@MUCSE501.eu.infineon.com>
References: <20120930233345.GJ30637@obsidianresearch.com>
	<20121010163324.GB5013@ennui.austin.ibm.com>
 <20121012205658.GM4124@obsidianresearch.com>
In-Reply-To: <20121012205658.GM4124@obsidianresearch.com>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.23.8.248]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----Original Message-----
> From: Jason Gunthorpe [mailto:jgunthorpe@obsidianresearch.com] 

> Using open/close is an interesting idea, but it wouldn't work. open()
> is coded to return EBUSY if another process has it open, rather than
> block, and spinning on open would be unacceptable.

Hmm, maybe write a small pass through program which opens /dev/tpm once and accepts its data via a socket or pipe?

Thanks,
Peter


