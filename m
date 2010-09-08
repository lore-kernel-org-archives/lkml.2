Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758607Ab0IHKOa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 06:14:30 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63198 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959Ab0IHKO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 06:14:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=X7WvrWB13cGUnw0vnbztdAuBRYTFq9XcyhykuwxVAK2RaN/cOR12S+YM0bV3PpDcOJ
         gjS1cMh82g9P5vvaKW/2TkaccirGU2ENSCeBaSlr+1Yc7a18k0VcR4F1Ydiee6xuLDKm
         J3gZlU7hQ+dU9kTyUtiAsA0BHDGPlhg6ISDFU=
Subject: Re: slow nanosleep?
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Joakim Tjernlund <joakim.tjernlund@transmode.se>,
        linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.2.00.1009081143200.2477@localhost6.localdomain6>
References: <OF71DD00AE.26643E4D-ONC1257798.00250630-C1257798.002A9748@transmode.se>
	 <1283932600.2880.1.camel@edumazet-laptop>
	 <OF5074952F.1B97B2B8-ONC1257798.002C51D7-C1257798.002C63A4@transmode.se>
	 <1283934289.2880.12.camel@edumazet-laptop>
	 <OF2B75FA7C.7064BC41-ONC1257798.00318FDA-C1257798.00329AEF@transmode.se>
	 <alpine.LFD.2.00.1009081143200.2477@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 08 Sep 2010 12:14:23 +0200
Message-ID: <1283940863.2880.37.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 08 septembre 2010 à 11:51 +0200, Thomas Gleixner a écrit :
> +       if (!tu.tv_sec && !tu.tv_usec)
> +               return 0;
> + 

You need tu.tv_nsec here ;)


