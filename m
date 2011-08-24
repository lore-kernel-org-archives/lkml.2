Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318Ab1HXOAS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 10:00:18 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42625 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362Ab1HXOAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 10:00:16 -0400
Date: Wed, 24 Aug 2011 09:57:37 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Dave Airlie <airlied@gmail.com>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: oops on rmmod iwlagn on 3.1.0-rc3
Message-ID: <20110824135737.GG9770@tuxdriver.com>
References: <CAPM=9tz6r60CvNuoCcg+6tckQAyCZwZjK4K3_ZA9dzkFn-B+Rg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPM=9tz6r60CvNuoCcg+6tckQAyCZwZjK4K3_ZA9dzkFn-B+Rg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 24, 2011 at 02:22:26PM +0100, Dave Airlie wrote:
> Running close to latest linus, just rmmod iwlagn.

I believe this will be fixed in -rc4 by commit
4eb60d869fdad7acd098b53bfd1863c311d8933d and commit
16a9d06c753abc44f66f88e03bbecb3f1e45d71b.

Hth!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
