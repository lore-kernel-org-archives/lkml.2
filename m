Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550Ab1LMMoo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 07:44:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36912 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752543Ab1LMMon (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 07:44:43 -0500
Message-ID: <4EE748BA.5080807@suse.cz>
Date: Tue, 13 Dec 2011 13:44:42 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Thomas Sailer <sailer@sailer.dynip.lugs.ch>
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net,
        steffen.koehler@tu-dresden.de
Subject: Re: bayom_epp patch
References: <1323777960.12740.2.camel@xbox360.hq.axsem.com>
In-Reply-To: <1323777960.12740.2.camel@xbox360.hq.axsem.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13.12.2011 13:06, Thomas Sailer wrote:
> -static const char bc_drvinfo[] = KERN_INFO "baycom_epp: (C) 1998-2000 Thomas Sailer, HB9JNX/AE4WA\n"
> -"baycom_epp: version 0.7\n";
> +static const char bc_drvinfo[] = KERN_INFO \
> +"baycom_epp: (C) 1998-2010 Thomas Sailer, HB9JNX/AE4WA\n\
> +baycom_epp: version 0.8 compiled " __TIME__ " " __DATE__ "\n";

Hi Thomas,

This change effectively reverts commit c1afba3 (baycom: Drop __TIME__
usage), which you acked.

Michal
