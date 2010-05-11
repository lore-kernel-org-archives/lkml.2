Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758033Ab0EKAya (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 20:54:30 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:52308 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755754Ab0EKAy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 20:54:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=ppymy4dxLxu0IOO92n1Fle27uuFobJndCZyoADrEq4jyTwSFq7D47bgyKmD1gfT/TG
         0IS4FHQPLgR5s3Kd+NuX6uVfmK7Xndm2th6zUuWlf9ki85fY5fPPibRDY2bltiWnDYct
         oKBxxmlHtNPG+dBw9rO9oHCBr2T82kxyJQeQc=
MIME-Version: 1.0
In-Reply-To: <AANLkTin6D2GP0yJJbPYGH1AcAM9-g219rAxSyW_ZlrXV@mail.gmail.com>
References: <AANLkTin6D2GP0yJJbPYGH1AcAM9-g219rAxSyW_ZlrXV@mail.gmail.com>
Date: Mon, 10 May 2010 17:54:25 -0700
X-Google-Sender-Auth: 2I2JRJPZRBpj0AmZnxkOGTUA8Ws
Message-ID: <AANLkTikjgoBQWqvNxncMUFqWOEXtq4ePvGkvF-m0sGUE@mail.gmail.com>
Subject: Re: PROBLEM: tickless scheduling
From: john stultz <johnstul@us.ibm.com>
To: Donald Allen <donaldcallen@gmail.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 10, 2010 at 5:18 PM, Donald Allen <donaldcallen@gmail.com> wrote:
> 1. Network file transfers and fscks stop on Toshiba netbook unless
> system receives external events

Can you provide /proc/timer_list output?

I assume booting with nohz=off from grub resolves the issue?

Sounds similar to https://bugzilla.kernel.org/show_bug.cgi?id=12118

thanks
-john
