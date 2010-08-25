Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321Ab0HYLXI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 07:23:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59703 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752922Ab0HYLXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 07:23:05 -0400
Date: Wed, 25 Aug 2010 13:23:01 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Borislav Petkov <bp@amd64.org>
Cc: =?ISO-8859-15?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>,
        Stephane Chatty <chatty@enac.fr>,
        Don Prince <dhprince-devel@yahoo.co.uk>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hid, Kconfig: Complete Kconfig prompt names
In-Reply-To: <20100816142607.GA2132@kryptos.osrc.amd.com>
Message-ID: <alpine.LNX.2.00.1008251322330.1019@pobox.suse.cz>
References: <20100816142607.GA2132@kryptos.osrc.amd.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Aug 2010, Borislav Petkov wrote:

> Make special HID devices' Kconfig names unambiguous, obviating the need
> to enter the help menu of each driver in order to know what hardware
> device it actually supports.

Fine by me. Applied, thanks for putting this into shape.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
