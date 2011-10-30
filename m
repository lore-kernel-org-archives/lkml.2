Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553Ab1J3JEz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 05:04:55 -0400
Received: from smtp1-g21.free.fr ([212.27.42.1]:53206 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754473Ab1J3JEy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 05:04:54 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Marek Vasut <marek.vasut@gmail.com>
Cc: linux-mtd@lists.infradead.org, dwmw2@infradead.org, dedekind1@gmail.com,
        mikedunn@newsguy.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/13]  DocG3 fixes and write support
References: <1319824292-11085-1-git-send-email-robert.jarzmik@free.fr>
	<201110300241.39534.marek.vasut@gmail.com>
X-URL: http://belgarath.falguerolles.org/
Date: Sun, 30 Oct 2011 10:04:44 +0100
In-Reply-To: <201110300241.39534.marek.vasut@gmail.com> (Marek Vasut's message
	of "Sun, 30 Oct 2011 02:41:39 +0200")
Message-ID: <87bosy6eab.fsf@free.fr>
User-Agent: Gnus/5.110018 (No Gnus v0.18) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marek Vasut <marek.vasut@gmail.com> writes:

> Hi,
>
> can you sum up the situation about the another (docg4) driver for us not 
> watching this too tightly? Was there any improvement/progress/... ?
The review is underway, my comments should be dealt with, and a V2 of the patch
should be sent. It's not in my hands.

The global view we have with Mike is that chips are different, and each one
deserves its own driver. Several registers are common, and the docg3.h could
become common.

Cheers.

--
Robert
