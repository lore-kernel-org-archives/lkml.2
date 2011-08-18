Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269Ab1HRIZM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 04:25:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49408 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755119Ab1HRIZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 04:25:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: build warning after merge of the moduleh tree
Date: Thu, 18 Aug 2011 10:26:51 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc2+; KDE/4.6.0; x86_64; ; )
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20110818150945.b429ef302fd45a6a309b52d4@canb.auug.org.au>
In-Reply-To: <20110818150945.b429ef302fd45a6a309b52d4@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108181026.51813.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thursday, August 18, 2011, Stephen Rothwell wrote:
> Hi Paul,
> 
> After merging the moduleh tree, today's linux-next build (powerpc
> ppc64_defconfig) produced this warning:
> 
> drivers/base/power/common.c:51:1: warning: data definition has no type or storage class
> drivers/base/power/common.c:51:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
> drivers/base/power/common.c:51:1: warning: parameter names (without types) in function declaration
> drivers/base/power/common.c:85:1: warning: data definition has no type or storage class
> drivers/base/power/common.c:85:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
> drivers/base/power/common.c:85:1: warning: parameter names (without types) in function declaration
> 
> Caused by the interaction of the module.h split up with commit
> 616d5814c605 ("PM: Reference counting of power.subsys_data") from the pm
> tree.
> 
> I added this patch for today (Rafael, in your tree this needs to include
> module.h) and will carry it as necessary:

Do you mean that drivers/base/power/common.c should include module.h
or something else?

Rafael
