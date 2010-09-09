Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984Ab0IILkT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 07:40:19 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:44991 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906Ab0IILkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 07:40:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=xquEDmpt4tf/nWNKQsbioTU3A5pLWeZ2196rVRnZb453t3e4OflhokBD2XcFiOKXbM
         mEpNCFNpZua5f3dbyU72C3RUrwyjIKH9LU28EN1mKwcowwXqyUTPtgDXuA2iTL01c3tQ
         iRkwgS3kmLNJXvy+JetjZeGy04G2+2QeSJKww=
MIME-Version: 1.0
In-Reply-To: <AANLkTikUadS+tj3ARdRqo=PSBVhTsJaUxaJv+=4hMf4s@mail.gmail.com>
References: <AANLkTikUadS+tj3ARdRqo=PSBVhTsJaUxaJv+=4hMf4s@mail.gmail.com>
Date: Thu, 9 Sep 2010 13:40:16 +0200
Message-ID: <AANLkTinuxPbOZhUokjvu-Q0C2SAW3vUH91LajU=t53SJ@mail.gmail.com>
Subject: Fwd: git diff - howto exclude dir from diff?
From: Jan III Sobieski <jan3sobi3ski@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maybe someone on LKML knows the answer?

---------- Forwarded message ----------
From: Jan III Sobieski <jan3sobi3ski@gmail.com>
Date: 2010/9/6
Subject: git diff - howto exclude dir from diff?
To: git@vger.kernel.org


Hi,

I wonder if it's possible to exclude a dir from the diff. I want to
get some diffstats from Linux tree

git diff v2.6.35..v2.6.36-rc3 --stat

but without drivers/staging/ dir. Is it possible?

Regards,
Jan

--
Jan III Sobieski



-- 
Jan III Sobieski
