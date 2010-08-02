Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889Ab0HBRkh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 13:40:37 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46500 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934Ab0HBRkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 13:40:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=ou5EQB3QhmzMC9IEzKiQ+VSrsjD61ubSMZE6bKR53/CjkCu7O6S28E6fEX2TJS3qyn
         vcYVsUk2ClpdNE9iauEuAitycxp1JL1m/V4iZ7wRWlxXLb6vWL06sy1JFGBJwulCkcv2
         uT7q9i9a8Y4r1oUb9sa1RFtpQR0qRnMs+r2AA=
MIME-Version: 1.0
In-Reply-To: <8c697ddc279b861006c90dbb320a6079f6c04f92.1280764206.git.qy03fugy@stud.informatik.uni-erlangen.de>
References: <cover.1280764206.git.qy03fugy@stud.informatik.uni-erlangen.de> 
	<8c697ddc279b861006c90dbb320a6079f6c04f92.1280764206.git.qy03fugy@stud.informatik.uni-erlangen.de>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 2 Aug 2010 13:40:15 -0400
Message-ID: <AANLkTikn68z2TRLYR4VV65qBdnCAWz1F97voGJGQ3x3F@mail.gmail.com>
Subject: Re: [PATCH 3/6] arch/blackfin: Remove CONFIG_MEM_GENERIC_BOARD
To: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
Cc: uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
        vamos-dev@i4.informatik.uni-erlangen.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 2, 2010 at 12:01, Christian Dietrich wrote:
> MEM_GENERIC_BOARD depends on GENERIC_BOARD, but this flag was removed
> in 4f25eb85d64640bc656e72917113a84701521b99, therefore all references
> to it from the source can be removed

thanks, this one is OK and i'll merge it in a bit
-mike
