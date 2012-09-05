Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758188Ab2IEJvI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 05:51:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54972 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750826Ab2IEJvG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 05:51:06 -0400
Date: Wed, 5 Sep 2012 11:50:55 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: =?ISO-8859-15?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-fbdev@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 0/6] HID: picoLCD additional fixes + CIR support
In-Reply-To: <20120819192859.74136bb0@neptune.home>
Message-ID: <alpine.LNX.2.00.1209051150390.11079@pobox.suse.cz>
References: <20120730213656.0a9f6d30@neptune.home> <20120819192859.74136bb0@neptune.home>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 Aug 2012, Bruno Prémont wrote:

> This series fixes some race conditions in picoLCD driver during remove()
> and adds support for IR functionality.

I have now applied the series, thanks Bruno.

-- 
Jiri Kosina
SUSE Labs
