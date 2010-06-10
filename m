Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464Ab0FJHRb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 03:17:31 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40788 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393Ab0FJHRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 03:17:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=MSQ9cpdTM4it2TkV6fE4xrCZrBPeEVTOw9cf7nHIPxlKeRsrhV1naPNhNblZZhAeT+
         u0EpQoPegJgWucX2UqN4HmqSLhmjyi0BLoO32YCLpa0A37N8iQeRh1pfnnQ6TQzVQDvg
         aJ0LbpspilQWew+MqbQsrAj6g8ANvOqv6TE8U=
MIME-Version: 1.0
Date: Thu, 10 Jun 2010 15:17:29 +0800
Message-ID: <AANLkTik6xP9vVEyW4QG-4RfZu-iEuHcl2pBV_-mfHP4y@mail.gmail.com>
Subject: oom killer and long-waiting processes
From: Ryan Wang <openspace.wang@gmail.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       kernelnewbies@nl.linux.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

        I have one question about oom killer:
If many processes dealing with network communications,
but due to bad network traffic, the processes have to wait
for a very long time. And meanwhile they may consume
some memeory separately for computation. The number
of such processes may be large.

        I wonder whether oom killer will kill these processes
when the system is under high pressure?

thanks,
