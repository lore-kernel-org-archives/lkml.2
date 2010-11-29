Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291Ab0K2OE7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 09:04:59 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51418 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754027Ab0K2OE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 09:04:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=tSKOkqm4fkqT/vq/jmleDGetXwdUUwhQEAXZObiwWD7PcksGyxHjPXZHOTHbyOjVey
         j8qtGYBC57X2R0grmY3igsDnJiAyfLm5nBlYthsClLYoRzg60F+QLRqcdhJZ9z1i5eOG
         fvHWUT1mIhCFy66+U753WaBB4bD2X8KPN8tG8=
MIME-Version: 1.0
In-Reply-To: <AANLkTikCt+OB6bq-7Kam40uo=-8Nt-fTa-_o0h835kkN@mail.gmail.com>
References: <AANLkTimjMR4wUYCfi7BoUcg6aBmuWcQW_dBo8svReWcS@mail.gmail.com>
	<201011281621.59036.maciej.rutecki@gmail.com>
	<AANLkTi=2O80uDo4DvjVj14Q0DGqTcZMQmnd-q2XV6f4K@mail.gmail.com>
	<AANLkTikCt+OB6bq-7Kam40uo=-8Nt-fTa-_o0h835kkN@mail.gmail.com>
Date: Mon, 29 Nov 2010 16:04:56 +0200
Message-ID: <AANLkTi=ERtG5spFqKH0Xc7JXKrM=YEwyrkb6RsdNbmKH@mail.gmail.com>
Subject: Re: 2.6.37-rc3-git4 bad desktop performance
From: Anca Emanuel <anca.emanuel@gmail.com>
To: maciej.rutecki@gmail.com, LKML <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ups, false alarm, sorry. (wrong git tree)

I can reproduce this only with:
git://git.kernel.org/pub/scm/linux/kernel/git/npiggin/linux-npiggin.git
vfs-scale-working
