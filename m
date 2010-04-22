Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444Ab0DVJZ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 05:25:28 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:48290 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862Ab0DVJZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 05:25:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=EwkbN7bfauxdKUQxGS66nZOdAPa3Lra/pBsb/xKh5o/uczzSk08VZxF3ybzk4gJj/y
         tIMdC7NETvZnA2Ia6KV+JOvxHikqm/+UfUEo1B0zoef3KsrXR42A7FANWz4foi7Gtofl
         HmtBFIwkug6xsi28h78oMEsIbtUBlHd73/uh0=
MIME-Version: 1.0
In-Reply-To: <20100416041509.GB1552@elf.ucw.cz>
References: <h2i45cc95261004120628kb38aabecr2552668f9e60d7c5@mail.gmail.com> 
	<20100415180200.GA1443@ucw.cz> <q2p72dbd3151004151642p9c0b8a14yc9de251b134aec08@mail.gmail.com> 
	<20100416041509.GB1552@elf.ucw.cz>
From: Mohamed Ikbel Boulabiar <boulabiar@gmail.com>
Date: Thu, 22 Apr 2010 11:25:01 +0200
Message-ID: <q2y45cc95261004220225zd1531585i4290a677457d2d6e@mail.gmail.com>
Subject: Re: Low-Level and Long-Term Battery Control
To: Pavel Machek <pavel@ucw.cz>
Cc: David Rees <drees76@gmail.com>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Anyway, this is done by smartbattery, not by OS.

I've found this for IBM laptops :
http://www.thinkwiki.org/wiki/Tp_smapi#Battery_charge_control_features

The features exist in windows for Sony Vaio laptops as the users say here
http://forum.notebookreview.com/showthread.php?t=288638
http://ubuntuforums.org/showthread.php?t=1225557

And it seems the same for Acer.


But it is very strange that only some companies exposes such features.
We can't find a way to do that by some reverse engineering ?
How does the lm_sensors guys discovering sensors in laptops ?
http://www.lm-sensors.org/


Any way, I always think that it can be controlled in some way, but we
don't have a public api explained for that.

M-I
