Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934093Ab1FWR5g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:57:36 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:49038 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933622Ab1FWR5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:57:33 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmwtM48/lk3c7qEu+E
X-RZG-CLASS-ID: mo00
Date: Thu, 23 Jun 2011 19:57:25 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: stable@kernel.org, linux-kernel@vger.kernel.org, stable-review@kernel.org,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [34-longterm 210/247] Input: xen-kbdfront - advertise either
 absolute or relative coordinates
Message-ID: <20110623175725.GA21283@aepfle.de>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-151-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1308850515-15242-151-git-send-email-paul.gortmaker@windriver.com>
User-Agent: Mutt/1.5.21 (2010-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 23, Paul Gortmaker wrote:

> From: Olaf Hering <olaf@aepfle.de>
> 
>                    -------------------
>     This is a commit scheduled for the next v2.6.34 longterm release.
>     If you see a problem with using this for longterm, please comment.
>                    -------------------
> 
> commit 8c3c283e6bf463ab498d6e7823aff6c4762314b6 upstream.

This one will introduce a regression, which will be fixed by upstream
commit c36b58e8a9112017c2bcc322cc98e71241814303

    Input: xen-kbdfront - fix mouse getting stuck after save/restore

Olaf
