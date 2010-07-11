Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563Ab0GKQeL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 12:34:11 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51259 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549Ab0GKQeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 12:34:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=lIRc3VGYYzenHjLuZ8T0qo7/gI7t6wJdYagVn4hFv2TnCHGrTNCCzVxjHvbHSTpwe+
         2F7rj9bkBRJjta/ttQcNCI1Uj0ccXAokTfJ5/VULto6Ek02frYdbz4Qz/PIBdK1J6vv0
         c40RLx66V2L6DlF1qF3dDtSWME/lTNnN6XBf8=
Subject: Re: stable? quality assurance?
From: Eric Dumazet <eric.dumazet@gmail.com>
To: William Pitcock <nenolod@dereferenced.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <11606525.291278863922663.JavaMail.root@ifrit.dereferenced.org>
References: <11606525.291278863922663.JavaMail.root@ifrit.dereferenced.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 11 Jul 2010 18:34:03 +0200
Message-ID: <1278866043.2538.140.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le dimanche 11 juillet 2010 à 19:58 +0400, William Pitcock a écrit :
> ----- "Eric Dumazet" <eric.dumazet@gmail.com> wrote:
> > 
> > Something like 2.6.32.16 : Its probably more stable than all 2.6.X
> > kernels.
> 
> 2.6.32.16 (possibly 2.6.32.15) has a regression where it is unusable
> as a Xen domU.  I would say 2.6.32.12 is the best choice since who knows
> what other regressions there are in .16.
> 

Yea, strictly speaking, you can be sure no kernel will be bug free,
ever.

This is why I said "probably more stable" ;)



