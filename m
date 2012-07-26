Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228Ab2GZAzb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 20:55:31 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:57330 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095Ab2GZAz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 20:55:29 -0400
Message-ID: <5010957D.1010500@landley.net>
Date: Wed, 25 Jul 2012 19:55:25 -0500
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Tim Gardner <tim.gardner@canonical.com>
CC: linux-kernel@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH] firmware: remove computone driver firmware and documentation
References: <1343234526-105460-1-git-send-email-tim.gardner@canonical.com>
In-Reply-To: <1343234526-105460-1-git-send-email-tim.gardner@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2012 11:42 AM, Tim Gardner wrote:
> As far as I can tell, the only Computone support left in the
> kernel is in drivers/tty/serial/8250/8250_pci.c. CONFIG_COMPUTONE
> is no longer a valid option. Therefore, remove firmware, documentation,
> and the last vestiges of this driver.
>
> Cc: Rob Landley <rob@landley.net>

Acked-by same.

Rob
-- 
GNU/Linux isn't: Linux=GPLv2, GNU=GPLv3+, they can't share code.
Either it's "mere aggregation", or a license violation.  Pick one.
