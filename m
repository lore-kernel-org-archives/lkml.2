Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757817Ab2HHG1e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 02:27:34 -0400
Received: from mga09.intel.com ([134.134.136.24]:60481 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757484Ab2HHG1c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 02:27:32 -0400
MIME-Version: 1.0
In-Reply-To: <1344407225-1276-1-git-send-email-dragos.tatulea@intel.com>
References: <1344407225-1276-1-git-send-email-dragos.tatulea@intel.com>
From: "Tatulea, Dragos" <dragos.tatulea@intel.com>
Date: Wed, 8 Aug 2012 09:27:10 +0300
Message-ID: <CAJ_JQ2WNeT-ymk9k3YNzh-cjaG5fEpC6cz1Ze9_RXRR4Uho6-w@mail.gmail.com>
Subject: Re: [PATCH] x86: set fpmath to 387 to avoid gcc warnings
To: hpa@linux.intel.com
Cc: linux-kernel@vger.kernel.org, Dragos Tatulea <dragos.tatulea@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 8, 2012 at 9:27 AM, Dragos Tatulea <dragos.tatulea@intel.com> wrote:
> If gcc has a different default fpmath set (ex: sse),
> many unuseful warnings will be spewed.
>
> This can affect out of tree modules that compile with
> -Werror (ex: systemtap stp scripts).
>
> Be paranoid and add -msoft-float as well to try to
> get an error if FP instructions are generated at all.
>
> Change-Id: If9271d7aea7371f394ede0bc5e3ed1383cdb0e1a
Ooops, leaked some trash. Patch re-sent.

Thanks,
Dragos
