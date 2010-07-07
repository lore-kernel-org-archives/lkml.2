Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758193Ab0GGWsb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 18:48:31 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39436 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758062Ab0GGWsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 18:48:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=cQya7uncU60mqOyts9Pa5xe0oclO1MNMyHzGoly1nBfAGO5YtjNWVAOiIky52uhY0n
         XSm/uTGX6GutnCFTbBBaXIXWLYUyISmVzr18qyLKtvCfEb1YYmwKqckWjUzJMjpUqNwG
         WD+Z/tsOQUkEmLHEaZH7HcTw33jVY4lmeHLf8=
MIME-Version: 1.0
Date: Thu, 8 Jul 2010 02:48:28 +0400
Message-ID: <AANLkTikkwvxiN1gnYtF5rhR5vW4ZZLcwneIbYGrqRTwU@mail.gmail.com>
Subject: Kernel changelog view by categories (web-script)
From: Igor Zhbanov <izh1979@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

I have written a small program that displays the Linux Kernel changelog
in a categorized way allowing to inspect only the changes under
the categories you are interested in. This makes reading
a big changelog for a new kernel less difficult.

The program is written in PHP. You can test it here:
http://i.clusteron.ru/clv.php

In the URL field of the form you should enter the URL of the changelog
you want to view. E.g.
http://www.kernel.org/pub/linux/kernel/v2.6/ChangeLog-2.6.34.1

After the page is loaded you can fold/unfold categories by clicking
[+] or category name.
You need to have JavaScript enabled in your browser.

The program is under GPLv2 license. So you can install it on your site.

You can download the source from http://i.clusteron.ru/clv.php.txt
ReadMe: http://i.clusteron.ru/clv_install.txt

Perhaps the program could be integrated in kernel.org site.
I think that viewing changelog by categories of changes is useful.

Probably some guidelines for changelog categories naming should be implemented.
