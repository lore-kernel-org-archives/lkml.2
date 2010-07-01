Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312Ab0GAPIY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 11:08:24 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:62600 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159Ab0GAPIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 11:08:23 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Subject: Re: [PATCH]kernel.h Move warning message about using kernel headers for userspace to types.h
Date: Thu, 1 Jul 2010 17:07:31 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, jkosina@suse.cz
References: <1277935785-6023-1-git-send-email-justinmattock@gmail.com> <201007010958.46720.arnd@arndb.de> <4C2C9962.3080307@gmail.com>
In-Reply-To: <4C2C9962.3080307@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201007011707.31783.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/QcYB1ZgSn1uV+li15Q3+Yac00iQJO+29G6yM
 14rRNddIEW3yrfWEg9h5aIALipZBU6zLeKR1dkyRfTmN8VTD/E
 SW1Z9W8QEJS0WO95lyKpA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 July 2010, Justin P. Mattock wrote:
> >>
> >> +#ifndef __EXPORTED_HEADERS__
> >> +#ifndef __KERNEL__
> >> +#warning "Attempt to use kernel headers from user space, see http://kernelnewbies.org/KernelHeaders"
> 
> so this is legit with the length of the statement? or should this be 
> broken down into a small quick line directing to a file with the address 
> or something

Yes, the length of the statement was never the problem, it only went wrong
because the // in the url gets interpreted as the start of a one-line comment.

	Arnd
