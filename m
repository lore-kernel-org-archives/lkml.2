Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425Ab0KZHfu (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 26 Nov 2010 02:35:50 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:37477 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186Ab0KZHfs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 02:35:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=tW/tO2MnlCIF5T6ZgwAc7IDF7YgMeAxEWgfSo1LA+8qveIE/KiqW4glQ8C9dhMbuYr
         DLETXgzTy15HpGCiQqcEadOfYbItes/1wDIgytAogt1mtSpFC6XkJIMcC5HmmDHIdYbD
         iHowgeamxTWl8+YoPj+CSo/4sCjes8uZWve4E=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=8nWFHeJ0Z-WhprNqZMGprMRG5LQ+b3wKoMWWv@mail.gmail.com>
References: <AANLkTinSigE4JPsFByPCkFd-+_oXQwR-V9=AsSH9Warz@mail.gmail.com>
	<1290755809.2678.14.camel@edumazet-laptop>
	<AANLkTi=8nWFHeJ0Z-WhprNqZMGprMRG5LQ+b3wKoMWWv@mail.gmail.com>
Date: Fri, 26 Nov 2010 08:35:48 +0100
Message-ID: <AANLkTi=bELgtgcWcy59KCvKwWWiuVZBb7e_hTSBHZ4cH@mail.gmail.com>
Subject: Re: Message
From: Alessandro Tagliapietra <tagliapietra.alessandro@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Venerdì 26 novembre 2010 alle 08:16 +0100, Eric Dumazet ha scritto:
> Thanksgiving might be the reason.

No problem :)
I've this problem (that i think also affect some people and probably
more in the future)

I've a asus p6x58d-e motherboard with a Marver 9128 (1b4b:91a3) Sata-6
controller. I've tried both ubuntu and fedora (that has newer kernel)
and both can't find the 2 western digital sata-6 drives configured in
raid0.

I've looked here
https://ata.wiki.kernel.org/index.php/SATA_hardware_features and the
Marvell	88SE9128/9120/9125/9111/9110 seems that they haven't any
driver right?

I'm new to the kernel mailing list, what are the next steps to help?

Best regards

Alessandro Tagliapietra

Sorry for double mail Eric but i haven't sent it on list.
