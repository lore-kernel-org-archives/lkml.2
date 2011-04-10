Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192Ab1DJO2q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Apr 2011 10:28:46 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:37258 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244Ab1DJO2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Apr 2011 10:28:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=DJee4doWSaGuSRyW+J0N/vDY8Yc1vSDo3kqeBaGSGoOotZXLFe+BvJNxB0MDzn5UvP
         yJ5QTcDuk0OJlvQtjvON1cHKFKoteeReOgM6SAih2pczSJHtF9yyaXigcjaMo97908IW
         rFbcfTcMj1AoGRhpiXs5hqxvLyDYbn8CgHLa4=
MIME-Version: 1.0
Date: Sun, 10 Apr 2011 11:28:44 -0300
Message-ID: <BANLkTinpQdbyTRY0m+UL7EKF3jAOv=aU1A@mail.gmail.com>
Subject: Kprobe
From: Artur Baruchi <mail.baruchi@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guys.

Im using kprobe to probe a kernel function (find_get_page) and I would
like to know more details, like which function is calling it, but I
couldnt figure out a way to do that. Is it possible to use kprobe or
other kind of probe to detect which function is calling find_get_page
?

Thanks in advance.

Att.
Artur Baruchi
