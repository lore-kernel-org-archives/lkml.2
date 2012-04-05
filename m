Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562Ab2DEIiU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 04:38:20 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:45146 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752755Ab2DEIiS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 04:38:18 -0400
Message-ID: <1333615097.23520.88.camel@joe2Laptop>
Subject: Re: [PATCH] printk: support structured and multi-facility log
 messages
From: Joe Perches <joe@perches.com>
To: Kay Sievers <kay@vrfy.org>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartmann <greg@kroah.com>
Date: Thu, 05 Apr 2012 01:38:17 -0700
In-Reply-To: <1333569554.864.3.camel@mop>
References: <1333569554.864.3.camel@mop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-04-04 at 21:59 +0200, Kay Sievers wrote:
> From: Kay Sievers <kay@vrfy.org>
> + * In a flat text stream of records, every record should be terminated
> + * by "\n\n", which separates the records from each other.

What do you do about "\n\n" in existing printks?

$ grep -rP --include=*.[ch] '\bprintk\b.*\\n\\n' *

