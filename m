Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734Ab2CDSiy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 13:38:54 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:59186 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754650Ab2CDSix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 13:38:53 -0500
Message-ID: <1330886330.7070.22.camel@joe2Laptop>
Subject: Re: Smatch v1.56 released
From: Joe Perches <joe@perches.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-kernel@vger.kernel.org, smatch@vger.kernel.org
Date: Sun, 04 Mar 2012 10:38:50 -0800
In-Reply-To: <20120304180455.GA1003@mwanda>
References: <20120304180455.GA1003@mwanda>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-03-04 at 21:04 +0300, Dan Carpenter wrote:
> Smatch still produces a lot of false positives.  Also as bugs get
> fixed in the kernel, the false positive to real bug ratio gets
> worse and worse.  But it does find real bugs as well.

Perhaps a database of known false positives and a mechanism
to use it to see only new instances could be created.

