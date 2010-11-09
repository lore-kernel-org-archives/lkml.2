Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810Ab0KITCJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 14:02:09 -0500
Received: from smtp.outflux.net ([198.145.64.163]:50178 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752344Ab0KITCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 14:02:07 -0500
Date: Tue, 9 Nov 2010 11:02:05 -0800
From: Kees Cook <kees.cook@canonical.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] x86: rename verify_cpu_64.S to verify_cpu.S
Message-ID: <20101109190205.GM5876@outflux.net>
References: <20101109181157.GE5876@outflux.net>
 <20101109181434.GF5876@outflux.net>
 <AANLkTi=BiYsoMJzzphh=ddpq=jkAMafnB0WdRkMXsd8L@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=BiYsoMJzzphh=ddpq=jkAMafnB0WdRkMXsd8L@mail.gmail.com>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pekka,

On Tue, Nov 09, 2010 at 08:46:42PM +0200, Pekka Enberg wrote:
> Please use "git format-patch -M" to detect renames when preparing patches.

Thanks, I've resent.

The proper use of format-patch should probably be covered in
Documentation/SubmittingPatches.txt but I didn't really see a good place
to put it.

Is there a ~/.gitconfig stanza that can be added to default to using -M
always?

Thanks,

-Kees

-- 
Kees Cook
Ubuntu Security Team
