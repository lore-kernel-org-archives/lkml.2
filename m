Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550Ab0IVGnB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 02:43:01 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55185 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392Ab0IVGnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 02:43:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=HvA9a8bHRsc030jDQooi+tvVBxQmzMuFpH56mmOSjf5u98I9Ow6okEz38TatlV5eD8
         kT/1nZ40B6PB1ZAtSs7DsNPPukxxHDCtNSyFMZf2ufBxGkFmH7d39DO1vHApMZUmXCot
         HaO9w5X0a28uiPj+3uoXRYH5rsCNr6Wnc9Yho=
Subject: Re: tcp_fastretrans_alert since 2.6.32 ?
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Sunny <sunyucong@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <AANLkTinnaA3Qgny45BRyW3i5u+nXn1XgWwkxA_QbN8xN@mail.gmail.com>
References: <AANLkTinnaA3Qgny45BRyW3i5u+nXn1XgWwkxA_QbN8xN@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Sep 2010 08:42:54 +0200
Message-ID: <1285137774.6378.166.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 21 septembre 2010 à 23:37 -0700, Sunny a écrit :


>     InMcastPkts: 2105
>     InBcastPkts: 12
>     InOctets: 1670966745
>     OutOctets: -417434189
>     InMcastOctets: 58940
>     InBcastOctets: 1792

Unrelated note :

Hmm, it seems ubuntu ships an old netstat binary... snmp values are
64bits nowadays...



