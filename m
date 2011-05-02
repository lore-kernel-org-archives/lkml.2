Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757104Ab1EBIzk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 04:55:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33798 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756961Ab1EBIzh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 04:55:37 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: SUSE
To: Klaus Dittrich <kladit@arcor.de>
Subject: Re: 2.6.38.5-rc1 usb problem
Date: Mon, 2 May 2011 10:57:11 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.39-rc4-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <20110502083117.GA1968@df1tl.local.here>
In-Reply-To: <20110502083117.GA1968@df1tl.local.here>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201105021057.11886.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 2. Mai 2011, 10:31:17 schrieb Klaus Dittrich:
> With 2.6.38.5-rc1 my usb-scanner will be not detected, with 2.6.38.4 it
> will.

This must be an odd side effect. Can you bisect?

	Regards
		Oliver
