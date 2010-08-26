Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688Ab0HZNhU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 09:37:20 -0400
Received: from cantor.suse.de ([195.135.220.2]:57568 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751615Ab0HZNhT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 09:37:19 -0400
Date: Thu, 26 Aug 2010 15:37:16 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Piotr Hosowicz <piotr@hosowicz.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Which kernel.org WWW is the master server?
In-Reply-To: <4C6D4864.2040002@example.com>
Message-ID: <alpine.LRH.2.00.1008261536290.2372@twin.jikos.cz>
References: <4C6D4864.2040002@example.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Aug 2010, Piotr Hosowicz wrote:

> I wrote a simple python script that tells me that a new kernel version
> appeared. The problem is that it is based exactly on this what appears on the
> webpage so sometimes it resolves the server IP that the version has changed,
> despite the fact that it is not true. Which server is the master server?

I guess that simply running

	finger @kernel.org

will give you exactly the information you are looking for which much less 
pain of connecting to www server, parsing html, etc.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

