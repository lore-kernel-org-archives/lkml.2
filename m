Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756469Ab1AaWb4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 17:31:56 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47541 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753451Ab1AaWbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 17:31:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=oZ6eJ0UgiNCVWY3s8tjxY6Gg1npOgLybxEokjAMpm64g73VvtIT+vq7ER2umLhoZMk
         xFv7bIUDmL5hKw+zWCyyvjnd0esoZrpP5ffskBLM2tIXhXEcz2WAlCGLsAmBQsUD8thC
         bPn6E9fW/eVS9VGJt5htjMUNIul5XubfbnaU4=
MIME-Version: 1.0
Date: Mon, 31 Jan 2011 17:31:53 -0500
Message-ID: <AANLkTikfO_uKa16eQJZgSHL6CjTassCmv7W_VcPDON9u@mail.gmail.com>
Subject: process exception
From: Sri Ram Vemulpali <sri.ram.gmu06@gmail.com>
To: Kernel-newbies <kernelnewbies@nl.linux.org>,
        linux-kernel-mail <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

  This is regarding segment fault. Is there any feature that we can
allow kernel to kill only the thread that generate seg fault rather
than killing whole process in which it is running. Why is that we did
not implement in such way. Is there any specific reason. Thanks in
advance for explanation.

-- 
Regards,
Sri.
