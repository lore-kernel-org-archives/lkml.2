Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752997Ab0H1QKQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 12:10:16 -0400
Received: from n63.bullet.mail.sp1.yahoo.com ([98.136.44.33]:37393 "HELO
	n63.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752806Ab0H1QKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 12:10:14 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 830813.39420.bm@omp123.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=f3S+qeISoXCNSGuWbl+fyKyFNrjAvDo87ed7y3vK8Rbg2eciYpcU8tjiXyVFcQRgCyNDmo5V/UfrMjsi7EXcx3PyFVM2MjmWJ3uhyrX2MoXhVCPasvyN1VJ79clhJtzdWXcF//K1KsvSmoOYMw70HO8GAE7zJWjxNuo0J8JAc2M=;
Message-ID: <581556.29157.qm@web180314.mail.gq1.yahoo.com>
X-YMail-OSG: faeJnaYVM1n0rtTKzJ5cf65HkhjDPE7Z6n.myMiwWcHto3Z
 56vLlROxPaQnVJdjkbD1ltpkE46bOvM9uZlwZDoKCnZMc5egawlJUwxVfTDx
 1.iWNeMl6vlrIrEcjA.PRMhPgUcSGYKGRv8Qn6sNN2QPCFh0.F1DNOuTcKJO
 .zTjpfjg5W7ocb_1Gg4ACg24b7WKAC6KHRVo9x3oSA9BZKbJi66z5uCBj0JT
 ojuNutR8gW_NwQj5ObVbH.tOMlrONQVQ.k7R3WEGRbto8ubNDmqLaAQVSgeu
 yxVDEeF8UswwjzSYGXwRx4yIi9cIJNqADwNYGsvijtV4-
X-Mailer: YahooMailClassic/11.3.2 YahooMailWebService/0.8.105.279950
Date: Sat, 28 Aug 2010 09:10:12 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH 2/7] drivers/usb/gadget: Remove double test
To: Thomas Dahlmann <dahlmann.thomas@arcor.de>, Julia Lawall <julia@diku.dk>
Cc: kernel-janitors@vger.kernel.org,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-geode@lists.infradead.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1283010066-20935-3-git-send-email-julia@diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please update $SUBJECT to say which driver is
affected; it's not everything in that directory,
and accurate GIT summaries help a lot.



