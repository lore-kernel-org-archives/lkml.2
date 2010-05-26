Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933989Ab0EZIpg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 04:45:36 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41858 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933449Ab0EZIpe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 04:45:34 -0400
Subject: Re: [PATCH 0/8] Suspend block api (version 8)
From: Peter Zijlstra <peterz@infradead.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <201005240246.55043.rjw@sisk.pl>
References: <1274482015-30899-1-git-send-email-arve@android.com>
	 <201005240246.55043.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 26 May 2010 10:45:33 +0200
Message-ID: <1274863533.5882.4864.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-24 at 02:46 +0200, Rafael J. Wysocki wrote:
> On Saturday 22 May 2010, Arve Hjønnevåg wrote:
> > This patch series adds a suspend-block api that provides the same
> > functionality as the android wakelock api. This version adds a
> > delay before suspending again if no suspend blockers were used
> > during the last suspend attempt.
> 
> Patches [1-6/8] applied to suspend-2.6/linux-next

So you're going to merge this junk?


