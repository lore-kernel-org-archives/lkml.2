Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504Ab0EGCaF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 22:30:05 -0400
Received: from mail-iw0-f197.google.com ([209.85.223.197]:62097 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936Ab0EGCaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 22:30:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:content-type;
        b=qiGd1lf/h7s8Y0uHUAErUlK7PDRyxd+W3lzz8/YO0cChALL4oLjLybfK7Wo5/ryk9F
         2p6WkVauwH05oIeGq7WziF3qt4+rTujasfm3uT7mDKAiAEo1rogByFku3w9ht0uAVZu8
         SOlnB/UOnS536dY68MiWbBWLMvpDTaJIqtVlA=
MIME-Version: 1.0
Date: Fri, 7 May 2010 12:30:03 +1000
X-Google-Sender-Auth: wmpWIitHeUoNjeHXT3yyGWD0Eow
Message-ID: <AANLkTingM7EsCtbElXTNzzjZt4kG5acQtbt5mJEIVbrW@mail.gmail.com>
Subject: Regression: monitor fails to sleep/suspend, forced to reboot to 
	correct. 2.6.34-rc6
From: Lex Hider <floss@lex.hider.name>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

My current setup has worked on previous kernels, I think the problem
has begun with 2.6.32.

If the monitor goes to standby/suspend it shows:

"Out of Range

H.frequency 33 KHz
V.frequency 31 Hz"

I can test this with running: "xset dpms force standby" or "xset dpms
force suspend".

I can no longer switch to console with Ctrl+Alt+F2, etc, and must
reboot to be able to use my system again.

Please advise what additional information/testing I can provide to
make sure this regression gets fixed for 2.6.34.

This bug appears to affect all recent distros as they are 2.6.32 based
(ubuntu lts, debian, rhel6).

I have reported the following bugs with little response. I am unsure
whether I have filed bugs in the correct place or against the correct
component.

http://bugs.freedesktop.org/show_bug.cgi?id=26423
https://bugzilla.redhat.com/show_bug.cgi?id=581898

Please CC me in on any replies.

Thanks,

Lex.
