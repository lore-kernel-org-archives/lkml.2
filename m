Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751572Ab1ELA54 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 20:57:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46079 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930Ab1ELA5z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 20:57:55 -0400
Subject: Re: [PATCH] arch/c6x: new architecture port for linux
From: Mark Salter <msalter@redhat.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20110511143442.7c163a74.rdunlap@xenotime.net>
References: <1305144843-5058-1-git-send-email-msalter@redhat.com>
	 <20110511143442.7c163a74.rdunlap@xenotime.net>
Content-Type: text/plain
Organization: Red Hat, Inc
Date: Wed, 11 May 2011 20:57:53 -0400
Message-Id: <1305161873.15167.78.camel@deneb.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-11 at 14:34 -0700, Randy Dunlap wrote:
> Please run the patches thru checkpatch.pl.  You don't have to fix
> everything that it whines about, just use good judgment.

Thanks Randy.

Was there anything particular that jumped out at you. I did run
checkpatch and there were 7 seven errors but none seemed fixable to
me (unless there really is a way to get rid of kernel_thread). The
warnings were almost all about exceeded 80 char line width. I have
been working on those for a while and there's a lot less than there
used to be! :-)

--Mark


