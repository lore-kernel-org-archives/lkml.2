Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353Ab0FVQG1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 12:06:27 -0400
Received: from smtp.outflux.net ([198.145.64.163]:60554 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752845Ab0FVQGZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 12:06:25 -0400
Date: Tue, 22 Jun 2010 09:06:13 -0700
From: ext Kees Cook <kees.cook@canonical.com>
To: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] security: Yama LSM
Message-ID: <20100622160613.GC5876@outflux.net>
References: <20100621213424.GG24749@outflux.net>
 <201006220028.o5M0Sbx7062650@www262.sakura.ne.jp>
 <20100622011452.GN24749@outflux.net>
 <4C20ABC0.5050908@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C20ABC0.5050908@nokia.com>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On Tue, Jun 22, 2010 at 03:25:36PM +0300, Dmitry Kasatkin wrote:
> What is YAMA?

"Yama" is just the name of the LSM.  It's inspired by:
http://en.wikipedia.org/wiki/Yama

> Where is the tree?

At the moment:
http://kernel.ubuntu.com/git?p=kees/linux-2.6.git;a=shortlog;h=refs/heads/yama

-Kees

-- 
Kees Cook
Ubuntu Security Team
