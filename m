Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289Ab1BBPJI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 10:09:08 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62560 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279Ab1BBPJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 10:09:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=DsPOzr8vGvtInOLiJGzB10FFz7mzbQlxLndtigmZcB5d9UK4y5G7SzYgF5PQXNvgRV
         yUb9DNZAoe5i71e9G2OBvQx/sTwwmoHfj3ySm/KR2Ntd6qZN7xrHOpC63PhXE/tf/s47
         aSUOryY18QOJgOazj4V1ufojyDwc4WZZLA17s=
Subject: Re: kernel 2.6.37 : oops in cleanup_once
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Yann Dupont <Yann.Dupont@univ-nantes.fr>
Cc: linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
In-Reply-To: <4D49726C.6020103@univ-nantes.fr>
References: <4D491B8D.1000107@univ-nantes.fr>
	 <1296643972.20445.9.camel@edumazet-laptop>
	 <1296645887.20445.11.camel@edumazet-laptop>
	 <4D495765.4090806@univ-nantes.fr>
	 <1296658407.20445.19.camel@edumazet-laptop>
	 <4D49726C.6020103@univ-nantes.fr>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Feb 2011 16:08:56 +0100
Message-ID: <1296659336.20445.22.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 02 février 2011 à 16:04 +0100, Yann Dupont a écrit :
> >
> Ok, will do it at 18:30 CET (to minimize impact)
> It the suspected bug SLUB related ?
> 

no : It can be a corruption from another part of kernel.

> The 2.6.34.2 kernel previously used on that server used SLAB.
> 
> 
> 2 questions :
> -How can I be sure slub_nomerge is active ? Boot message ?


# ls -l /sys/kernel/slab/

If you have symlinks : merge is on (default)

If you dont have symlinks : nomerge is in action

> -Is there a very severe impact on performance ?
> 

not at all

> Regards,
> 


