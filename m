Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760492Ab2FDMd6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 08:33:58 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:42376 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760429Ab2FDMd5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 08:33:57 -0400
Message-ID: <1338813236.8574.6.camel@joe2Laptop>
Subject: Re: Is this code right in zram?
From: Joe Perches <joe@perches.com>
To: Jerome Marchand <jmarchan@redhat.com>
Cc: John Moser <john.r.moser@gmail.com>, linux-kernel@vger.kernel.org
Date: Mon, 04 Jun 2012 05:33:56 -0700
In-Reply-To: <4FCCA543.3030603@redhat.com>
References: <4FC7E610.5060207@gmail.com> <4FCCA543.3030603@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-04 at 14:08 +0200, Jerome Marchand wrote:
> It probably doesn't matter much.

Likely true.

> Apparently kcalloc() never got  a lot
> of success and kzalloc(sizeof(foo) * num_foos) type of allocation are
> more popular.

Likely false, especially in new code.

If you did greps, perhaps you are including the
	k.alloc(sizeof(*foo), GFP)
forms in your uses multiply counts.


