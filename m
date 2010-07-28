Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359Ab0G1PPJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 11:15:09 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37412 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755242Ab0G1PPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 11:15:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=msqC3pDESjf5G9xrjmqQFV5HZADuLLQCbYGX83y3+vpaCrzWvMTO/FyQt7dSCVroIi
         w0rUhDSAi/64sAYRkKjWFydMaZj5lmaL0+M3q/e+UIH51No0+gdWIt1dJU93aHv12Q+2
         OpP7pWUpbaSTjekph98jfIS7wa7lRaVwfGSAk=
MIME-Version: 1.0
In-Reply-To: <86bp9rhew1.fsf@peer.zerties.org>
References: <86bp9rhew1.fsf@peer.zerties.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 28 Jul 2010 11:14:43 -0400
Message-ID: <AANLkTi=AsMKL9vdfiFaetmns1D4t4f46VMfyvunsSfBR@mail.gmail.com>
Subject: Re: CONFIG_IPIPE
To: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
Cc: uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
        vamos-dev@i4.informatik.uni-erlangen.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 28, 2010 at 10:14, Christian Dietrich wrote:
> I've seen, that there is no configuration Option for CONFIG_IPIPE in the
> vanilla kernel. There are 36 cases of dead blocks within arch/blackfin
> referencing CONFIG_IPIPE. So i thought, i ask, if this is a out of tree
> development, which should be merged in the future, before i start
> writing patches.

this is expected behavior.  apply the xenomai patch.
-mike
