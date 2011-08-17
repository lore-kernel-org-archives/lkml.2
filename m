Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351Ab1HQQkv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 12:40:51 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:41509 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754183Ab1HQQkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 12:40:41 -0400
Date: Wed, 17 Aug 2011 09:40:39 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Mimi Zohar <zohar@us.ibm.com>,
        Kylene Hall <kjhall@us.ibm.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        James Morris <jmorris@namei.org>,
        linux-security-module@vger.kernel.org
Subject: Re: linux-next: Tree for Aug 17 (EVM)
Message-Id: <20110817094039.0bba7092.rdunlap@xenotime.net>
In-Reply-To: <20110817151628.93911903cac8f207e9f01457@canb.auug.org.au>
References: <20110817151628.93911903cac8f207e9f01457@canb.auug.org.au>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Aug 2011 15:16:28 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> The powerpc allyesconfig build still fails today.

warning: (EVM) selects TRUSTED_KEYS which has unmet direct dependencies (KEYS && TCG_TPM)

EVM should depend on TCG_TPM [or select it :( ].


Can we get an EVM entry added to MAINTAINERS, please?

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
