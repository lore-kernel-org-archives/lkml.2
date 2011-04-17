Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947Ab1DQTrG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 15:47:06 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:64771 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857Ab1DQTq6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 15:46:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=GFyvCI7aNXnsWdnhDAZaLSBjmHN7P36xRd35j9MichbHkLi802N9rBF8+7Z2203zeG
         fHReTUwnrk/xJIaeyS+LEjxmB37T1h9LPjOzLoQsnbWJemFfmlQK8vEGpm0Ulo/+zdFN
         RnkW6yxCyxKX02I5zkN7Xtwb5Zqm6EO+5fAN0=
MIME-Version: 1.0
In-Reply-To: <IqJL5EkbqD.A.lyF.a5uqNB@chimera>
References: <sam8u5dLkaB.A.afE.53uqNB@chimera>
	<IqJL5EkbqD.A.lyF.a5uqNB@chimera>
Date: Sun, 17 Apr 2011 23:46:57 +0400
Message-ID: <BANLkTimGFqP7q845+zYnyjcO0PvoBGX_qg@mail.gmail.com>
Subject: Re: [Bug #29852] 2.6.38-rc5: nfsd: page allocation failure. spinlock
 trylock failure on UP
From: Alexander Beregalov <a.beregalov@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 April 2011 17:52, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.37 and 2.6.38.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.37 and 2.6.38.  Please verify if it still should
> be listed and let the tracking team know (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=29852
> Subject         : 2.6.38-rc5: nfsd: page allocation failure. spinlock trylock failure on UP
> Submitter       : Alexander Beregalov <a.beregalov@gmail.com>
> Date            : 2011-02-21 20:33 (56 days old)
> Message-ID      : <AANLkTi=14N_c_B7mLY0H8Dt8pte6C0mjFnVuC37e44Hs@mail.gmail.com>
> References      : http://marc.info/?l=linux-netdev&m=129832042402668&w=2
>

Hi, Rafael.
I do not see the problem since that time.
Is it enough reason for closing it?
