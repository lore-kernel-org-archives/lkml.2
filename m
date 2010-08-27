Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753671Ab0H0WcG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 18:32:06 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:58234 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753558Ab0H0WcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 18:32:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=k+9mpk26DSy/n7UmO/maMUa3ijM/+q3o+yRI6PimlQ/vyWdsAUKreBnJ6qdY6ubTr+
         2numAEd1CxgjyBsiDSPli5iEUap6TmY5gH8GTHSdakpK7jBDIxJFxmojzh0NjQ1BeiOR
         cSs2t6L75P3mDx8pxbgUlpn9Dvd8Y0ldkYZpc=
MIME-Version: 1.0
Date: Fri, 27 Aug 2010 18:32:03 -0400
Message-ID: <AANLkTim7eHwkbbOHdXax7dQiMzSAktxjNYBpQjKOwTUy@mail.gmail.com>
Subject: LDD examples
From: Someone Something <fordhaivat@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I downloaded the LDD examples
(http://examples.oreilly.com/9780596005900/), and I unzipped the file
and just tried building it with make just to see if it built properly
and here are the errors I get:
setlevel.c:30: error: expected declaration specifiers or '...' before 'type'
setlevel.c:30: error: expected declaration specifiers or '...' before 'bufp'
setlevel.c:30: error: expected declaration specifiers or '...' before 'len'
setlevel.c:30: warning: data definition has no type or storage class
setlevel.c:30: warning: type defaults to 'int' in declaration of '_syscall3'
setlevel.c: In function 'main':
setlevel.c:41: warning: implicit declaration of function 'syslog'

have any of use experienced these errors? Is this book out of date?
Alternatives?
