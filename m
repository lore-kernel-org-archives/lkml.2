Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917Ab2BORkR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 12:40:17 -0500
Received: from blackhole.sdinet.de ([176.9.52.58]:52468 "EHLO mail.sdinet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751873Ab2BORkQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 12:40:16 -0500
Date: Wed, 15 Feb 2012 18:40:14 +0100 (CET)
From: Sven-Haegar Koch <haegar@sdinet.de>
X-X-Sender: haegar@aurora64
To: Sven Geggus <lists@fuchsschwanzdomain.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: Core i7-3960X Only 4 cores detected
In-Reply-To: <jhgq81$s95$1@ultimate100.geggus.net>
Message-ID: <alpine.DEB.2.02.1202151837150.31643@aurora64>
References: <jhgq81$s95$1@ultimate100.geggus.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Feb 2012, Sven Geggus wrote:

> I just booted Linux (vanilla kernel 3.2.5) on an i7-3960X machine.

> CONFIG_NR_CPUS=8

Increase this value.

c'ya
sven-haegar

-- 
Three may keep a secret, if two of them are dead.
- Ben F.
