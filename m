Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752320Ab0DMJmx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 05:42:53 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:64334 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002Ab0DMJmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 05:42:52 -0400
From: "Hans-Peter Jansen" <hpj@urpla.net>
To: Dave Chinner <david@fromorbit.com>
Subject: Re: 2.6.34-rc3: simple du (on a big xfs tree) triggers oom killer [bisected: 57817c68229984818fea9e614d6f95249c3fb098]
Date: Tue, 13 Apr 2010 11:42:33 +0200
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, opensuse-kernel@opensuse.org,
       xfs@oss.sgi.com
References: <201004050049.17952.hpj@urpla.net> <201004131050.36395.hpj@urpla.net> <20100413091823.GD7544@dastard>
In-Reply-To: <20100413091823.GD7544@dastard>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201004131142.33518.hpj@urpla.net>
X-Provags-ID: V01U2FsdGVkX1/TOwnXWvtHHwsJloGzkcYGA3JDA7/FHbD36Bm
 pbOJYYPy9ApQaQlLjcvaC7Nwkqt7qr84yQMp7nyHAtToeO6YYB
 WNnoqiLvhduRoJ7LYteFw0pOpM5paGB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 April 2010, 11:18:23 Dave Chinner wrote:
> On Tue, Apr 13, 2010 at 10:50:35AM +0200, Hans-Peter Jansen wrote:
> >
> > Dave, may I ask you kindly for briefly elaborating on the worst
> > consequences of just reverting this hunk, as I've done before?
>
> Well, given that is the new shrinker code generating the warnings,
> reverting/removing that hunk will render the patch useless :0

Excuse me, I didn't express myself well. I'm after the consequences of 
applying the revert, that I posted a few messages above. 

> I'll get you a working 2.6.33 patch tomorrow - it's dinner time
> now....

Cool, thanks. 

Have a nice dinner,
Pete



