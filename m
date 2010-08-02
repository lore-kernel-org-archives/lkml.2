Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839Ab0HBRjy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 13:39:54 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60170 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438Ab0HBRjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 13:39:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=iEbT0IFIDpnPQzKT82QTu42RUt+3A7Axunnd18FJkX+BR9WGUAfoFi6j3VhIfcXB92
         +hjQxYfgTeAuUOI3NHcK2WAChndkYvC8up6RhUZBX18Rsrlx05jTwwVHzNRBlUyi4p20
         heO6KzqgoD3RhRTk1VxynWsgtaqiwTCB9ulF0=
MIME-Version: 1.0
In-Reply-To: <ccdd80e85789f8b5cc2606195f331b3339e565a2.1280764206.git.qy03fugy@stud.informatik.uni-erlangen.de>
References: <cover.1280764206.git.qy03fugy@stud.informatik.uni-erlangen.de> 
	<ccdd80e85789f8b5cc2606195f331b3339e565a2.1280764206.git.qy03fugy@stud.informatik.uni-erlangen.de>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 2 Aug 2010 13:39:31 -0400
Message-ID: <AANLkTi=M+VVRbs4rj7ayqW+RQwMCg7Rvvy_YsHmm7AGt@mail.gmail.com>
Subject: Re: [PATCH 6/6] arch/blackfin: Removing dead SND_BLACKFIN_AD183X
To: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
Cc: uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
        vamos-dev@i4.informatik.uni-erlangen.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 2, 2010 at 12:03, Christian Dietrich wrote:
> CONFIG_SND_BLACKFIN_AD183X doesn't exist in Kconfig, therefore removing
> all references to it from the source.

NAK: this driver is pending for the ASoC tree
-mike
