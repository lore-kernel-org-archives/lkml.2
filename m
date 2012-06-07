Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760027Ab2FGEkV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 00:40:21 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:51806 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760002Ab2FGEkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 00:40:18 -0400
Subject: Re: vmsplice triggering bug in kfree.
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, axboe@kernel.dk
In-Reply-To: <1339043263.26966.79.camel@edumazet-glaptop>
References: <20120607025117.GA28261@redhat.com>
	 <1339043263.26966.79.camel@edumazet-glaptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Jun 2012 06:40:13 +0200
Message-ID: <1339044013.26966.80.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-07 at 06:27 +0200, Eric Dumazet wrote:

> Thanks Dave, I'll take a look today on this report.
> 

OK, trivial bug, I am testing a fix, thanks again.


