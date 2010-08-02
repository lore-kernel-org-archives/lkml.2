Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586Ab0HBRet (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 13:34:49 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47349 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924Ab0HBRes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 13:34:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=YGkONZT8HJE4/ffmeGyM7CH/Rtak9imwrArZ+T87BZAchB12sS8T01dMRoJuYOIn/f
         bIyYAmEzG0o/+0bDqq31GdhevG5l/9iWLdbBj0CfqnZAUPg8CF4mn11Qvgo3+b/T56oR
         HLKfLj5mOsQNuHf8pqKGEMK8LNWQxS5LJuL8U=
MIME-Version: 1.0
In-Reply-To: <1bdd2af4056783afe300100b2a067d111ba4e7ca.1280764206.git.qy03fugy@stud.informatik.uni-erlangen.de>
References: <cover.1280764206.git.qy03fugy@stud.informatik.uni-erlangen.de> 
	<1bdd2af4056783afe300100b2a067d111ba4e7ca.1280764206.git.qy03fugy@stud.informatik.uni-erlangen.de>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 2 Aug 2010 13:34:27 -0400
Message-ID: <AANLkTin5-VUR3CemcPfCLaaLSbMo-Xx=Dtt=ssUzgxr=@mail.gmail.com>
Subject: Re: [PATCH 5/6] arch/blackfin: Remove dead CONFIG_ADF702X
To: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
Cc: uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
        vamos-dev@i4.informatik.uni-erlangen.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 2, 2010 at 12:02, Christian Dietrich wrote:
> ADF702X doesn't exist in Kconfig, therefore removing all references to
> it from the source.

NAK: this driver is pending for the netdev tree

btw, any ADI/Blackfin maintainer is on the uclinux-dist mailing list,
so dont need to include them directly
-mike
