Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758298Ab2CWSHh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 14:07:37 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:47974 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753508Ab2CWSHg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 14:07:36 -0400
Message-ID: <1332526054.18842.2.camel@joe2Laptop>
Subject: Re: [PATCH] MAINTAINERS: Adding PCDP console maintainer information
From: Joe Perches <joe@perches.com>
To: Khalid Aziz <khalid@hp.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Date: Fri, 23 Mar 2012 11:07:34 -0700
In-Reply-To: <20120323174457.GA12579@hp.com>
References: <20120323174457.GA12579@hp.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-03-23 at 11:44 -0600, Khalid Aziz wrote:
> This patch adds missing maintainer info for PCDP console code.
[]
> diff --git a/MAINTAINERS b/MAINTAINERS
[]
> +PCDP CONSOLE

might be better as PCDP - PRIMARY CONSOLE AND DEBUG PORT

> +M:	Khalid Aziz <khalid.aziz@hp.com>
> +S:	Maintained
> +F:	drivers/firmware/pcdp.*


