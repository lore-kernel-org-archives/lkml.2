Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471Ab0EWWOw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 18:14:52 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37555 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754245Ab0EWWOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 18:14:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=bPq/GO8V/yn6BF3iSa6bSLQ+7+cOSCNw6EqcXb2acuXfKglDBIgP80Qy7zs+Ql+B93
         6uUQQiLAm2ne9z4ORvSok43WHiFINNq99+IDPDADT7Y6MxR12uMUgOT84ZwsmGBAixoi
         aCd8lYiXoNYvi873uzHYcs6LksktrL3PHwd2M=
MIME-Version: 1.0
Date: Mon, 24 May 2010 00:14:49 +0200
Message-ID: <AANLkTinHkcWaHs8Hf6zvRjftC5hPkpHbC2LTaz-h4TJ3@mail.gmail.com>
Subject: CPU #1 not responding Problem
From: Jacek J <69rydzyk69@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
sometimes (very rarely), when I boot my machine, I get messages that
some cores are not responding (#0, #,1 #,2). #3 is responding and
system boots with one core. After reboot it boots fine with all 4
cores. My CPU is Phenom II X940, I use archlinux.
Any clues?

Cheers,
Jack
