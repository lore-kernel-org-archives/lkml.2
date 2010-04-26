Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603Ab0DZJod (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 05:44:33 -0400
Received: from cantor.suse.de ([195.135.220.2]:55690 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751312Ab0DZJob (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 05:44:31 -0400
Date: Mon, 26 Apr 2010 11:44:27 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: =?ISO-8859-15?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH] hid: fix picolcd's version parsing
In-Reply-To: <20100425213140.371194b0@neptune.home>
Message-ID: <alpine.LNX.2.00.1004261144170.7579@pobox.suse.cz>
References: <20100425213140.371194b0@neptune.home>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Apr 2010, Bruno Prémont wrote:

> During grouping of version checking code bootloader mode's version
> bytes got swapped. Fix their order.

Applied, thanks Bruno.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
