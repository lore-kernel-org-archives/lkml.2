Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908Ab1FIT0t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 15:26:49 -0400
Received: from mail.perches.com ([173.55.12.10]:2708 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751481Ab1FIT0s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 15:26:48 -0400
Subject: Re: [RFC PATCH] checkpatch.pl: Add ability to ignore various
 messages
From: Joe Perches <joe@perches.com>
To: Andy Whitcroft <apw@canonical.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Graeme Russ <graeme.russ@gmail.com>,
        U-Boot Users <u-boot@lists.denx.de>, linux-kernel@vger.kernel.org
In-Reply-To: <b41636a5e5756917b07e50a4b8309dbb092b0a17.1303778411.git.joe@perches.com>
References: <1303713156.1745.38.camel@Joe-Laptop>
	 <b41636a5e5756917b07e50a4b8309dbb092b0a17.1303778411.git.joe@perches.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Jun 2011 12:26:46 -0700
Message-ID: <1307647606.13329.40.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-25 at 17:43 -0700, Joe Perches wrote:
> Some users would like the ability to not emit some of the
> messages that checkpatch produces.
> 
> Add command line option to "--ignore" various message types.
> Add .checkpatch.conf file to store a default set of "ignore" flags
> Categorize all ERROR, WARN and CHK types with flags.

Did anyone object to this?
Andrew M, would you take a current version of this?


