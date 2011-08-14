Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229Ab1HND1t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 23:27:49 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:61551 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641Ab1HND1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 23:27:48 -0400
Subject: Re: [PATCH 4/4]sound:pci Fix typo "shud"
From: Calvin Walton <calvin.walton@kepstin.ca>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org
Date: Sat, 13 Aug 2011 23:27:44 -0400
In-Reply-To: <1313195174-4464-4-git-send-email-justinmattock@gmail.com>
References: <1313195174-4464-1-git-send-email-justinmattock@gmail.com>
	 <1313195174-4464-4-git-send-email-justinmattock@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 
Content-Transfer-Encoding: 7bit
Message-ID: <1313292466.12679.1.camel@ayu>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-08-12 at 17:26 -0700, Justin P. Mattock wrote:
> From: "Justin P. Mattock" <justinmattock@gmail.com>
> 
> The patch below fixes a typo shud.

> diff --git a/sound/pci/au88x0/au88x0_a3d.c b/sound/pci/au88x0/au88x0_a3d.c

> -/* A3D base support init/shudown */
> +/* A3D base support init/shutown */

I agree that this is a typo, but you don't have the fix quite right :)
"shutdown" would be better.

-- 
Calvin Walton <calvin.walton@kepstin.ca>

