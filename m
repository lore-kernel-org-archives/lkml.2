Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759280Ab2HWVgi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 17:36:38 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:60519 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754134Ab2HWVgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 17:36:35 -0400
Message-ID: <5036A25D.40700@landley.net>
Date: Thu, 23 Aug 2012 16:36:29 -0500
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Oskar Schirmer <oskar@scara.com>
CC: trivial@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, John Anthony Kazos Jr <jakj@j-a-k-j.com>
Subject: Re: [PATCH] Documentation: fix broken utf8 encoding
References: <1345542849-13621-1-git-send-email-oskar@scara.com>
In-Reply-To: <1345542849-13621-1-git-send-email-oskar@scara.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2012 04:54 AM, Oskar Schirmer wrote:
> conversion to utf8 left some extra control character here,
> remove it.
> 
> Signed-off-by: Oskar Schirmer <oskar@scara.com>
> Cc: John Anthony Kazos Jr <jakj@j-a-k-j.com>
> Cc: Rob Landley <rob@landley.net>

Acked-by: Rob Landley <rob@landley.net>

And it's a job for trivial@.

Rob
-- 
GNU/Linux isn't: Linux=GPLv2, GNU=GPLv3+, they can't share code.
Either it's "mere aggregation", or a license violation.  Pick one.
