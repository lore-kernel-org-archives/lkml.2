Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758527Ab0LMRdx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 12:33:53 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43564 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933Ab0LMRdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 12:33:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=AvYZWZAP8Va7U6sxF3ag9JFBDgSxkOAd4QA7OzOjNwzyjLwz1FA15Nys/cYQFDJuEA
         41q965XGKAPbEKrm0JYNFtsNmCnmj38t0rHLZgzKXcu4csEMoZf1kg7rRXnhHG1TmNoe
         DhyD/lbGRlqSOIexl/vox18ZqbEmSETxE1CLE=
MIME-Version: 1.0
In-Reply-To: <201012130846.16522.holgerschurig@gmail.com>
References: <AANLkTik4W+UxgyPjVyHDeEFTRCkXdDBQ9obgPkpnhzGW@mail.gmail.com> <201012130846.16522.holgerschurig@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 13 Dec 2010 09:26:27 -0800
Message-ID: <AANLkTimWaopJnU5T6OZvqm4YSvSZeXs0dh7oMfU+ERJ8@mail.gmail.com>
Subject: Re: Start dropping PCMCIA from compat-wireless for 2.6.38+
To: Holger Schurig <holgerschurig@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 12, 2010 at 11:46 PM, Holger Schurig
<holgerschurig@gmail.com> wrote:
> Please, if the burden is not too much, keep it for the benefit of
> embedded people.
>
> If you have some embedded device (e.g. ARM based), it's usually not so
> easy to hieve this device to newest 2.6.3[5-7] kernel. However, it's
> easy to use your adapted kernel, and compile compat-wireless against it.
>
> I'm in such a situation with libertas_cs.

You use libertas_cs on an embedded device with compat-wireless, OK,
thanks for the feedback. If you can help with patches when PCMCIA crap
is advanced that would help too.

  Luis
