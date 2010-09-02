Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393Ab0IBOV0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 10:21:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44538 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752969Ab0IBOVY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 10:21:24 -0400
From: Andreas Schwab <schwab@redhat.com>
To: David Howells <dhowells@redhat.com>
Cc: gerg@snapgear.com, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] M68K: Use CONFIG_MMU not __uClinux__ to select m68knommu contributions
References: <19747.1283422807@redhat.com>
	<20100902102158.19806.14133.stgit@warthog.procyon.org.uk>
X-Yow: ... I live in a FUR-LINE FALLOUT SHELTER
Date: Thu, 02 Sep 2010 16:21:08 +0200
In-Reply-To: <20100902102158.19806.14133.stgit@warthog.procyon.org.uk> (David
	Howells's message of "Thu, 02 Sep 2010 11:21:58 +0100")
Message-ID: <m38w3kns4r.fsf@hase.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> writes:

> Use CONFIG_MMU not __uClinux__ to select m68knommu contributions as nothing in
> the arch defines __uClinux__ for the build.

You are using the wrong compiler.

Andreas.

-- 
Andreas Schwab, schwab@redhat.com
GPG Key fingerprint = D4E8 DBE3 3813 BB5D FA84  5EC7 45C6 250E 6F00 984E
"And now for something completely different."
