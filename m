Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547Ab2BOSH7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 13:07:59 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:59988 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754182Ab2BOSH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 13:07:57 -0500
Message-ID: <1329329274.20736.1.camel@joe2Laptop>
Subject: Re: [PATCH next] watchdog: Use pr_<fmt> and pr_<level>
From: Joe Perches <joe@perches.com>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-watchdog <linux-watchdog@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 15 Feb 2012 10:07:54 -0800
In-Reply-To: <1328662556.15787.8.camel@joe2Laptop>
References: <1328662556.15787.8.camel@joe2Laptop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-02-07 at 16:55 -0800, Joe Perches wrote:
> Use the current logging styles.
> 
> Make sure all output has a prefix.
> Add missing newlines.
> Remove now unnecessary PFX, NAME, and miscellaneous other #defines.
> Coalesce formats.

Ping?

