Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698Ab0G0RWa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 13:22:30 -0400
Received: from mail.perches.com ([173.55.12.10]:2103 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751772Ab0G0RW3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 13:22:29 -0400
Subject: Re: [PATCH] checkpatch: Add warnings for use of mdelay()
From: Joe Perches <joe@perches.com>
To: Israel Schlesinger <israels@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, apw@canonical.com, akpm@linux-foundation.org
In-Reply-To: <4C4F132F.6020401@codeaurora.org>
References: <4C4F132F.6020401@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Jul 2010 10:22:26 -0700
Message-ID: <1280251346.2082.69.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-07-27 at 10:11 -0700, Israel Schlesinger wrote:
> +		if ($line =~ /\bmdelay\(/) {
 
That should be:

		if ($line =~ /\bmdelay\s*\(/) {


