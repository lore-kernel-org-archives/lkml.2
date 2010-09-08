Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758532Ab0IHIY6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 04:24:58 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47298 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758518Ab0IHIYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 04:24:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=iuMusX0PKBr6yDsXE8ZKeLS4BksBy2wu0oiGbKzOOSfUH88L+DakxKcLiNsc/GEVx4
         wdJHIV3+jtDW5occcqmEQURpLfSzLP65sY2ZG9nYaHpjKjrYBDhm0FLKQ890RgbkKgXf
         rAex3tmoqZPrtNul6/9GpCgYYDVXAAE6Q9MDQ=
Subject: Re: slow nanosleep?
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <OF5074952F.1B97B2B8-ONC1257798.002C51D7-C1257798.002C63A4@transmode.se>
References: <OF71DD00AE.26643E4D-ONC1257798.00250630-C1257798.002A9748@transmode.se>
	 <1283932600.2880.1.camel@edumazet-laptop>
	 <OF5074952F.1B97B2B8-ONC1257798.002C51D7-C1257798.002C63A4@transmode.se>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 08 Sep 2010 10:24:49 +0200
Message-ID: <1283934289.2880.12.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 08 septembre 2010 à 10:04 +0200, Joakim Tjernlund a écrit :

> That makes litte difference:
> root@localhost ~ # ./nanosleep
> nanosleep
> req:0 :0
> tv_res:0 :112
> 

Here, result is 30 (with prctl())
instead of 95 (without)




