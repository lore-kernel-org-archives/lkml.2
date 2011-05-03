Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561Ab1ECQRj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 12:17:39 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38038 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853Ab1ECQRh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 12:17:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=aD2+wrB8/4Jhl+at+MITAAYLW4b+e4YCv5aTZUXqwJOknBY21BWVs5Eyeb6u1iudbF
         UU3e8NenBOPVr/qaTRzwAf0QK2NInPNPTnt/FgX4lYBH9zPDaJac+48DFds11BShn5uL
         9sQpgtEdtJpiOioP+808c+9aN2gmaqDGcW/ME=
MIME-Version: 1.0
Date: Tue, 3 May 2011 13:17:36 -0300
Message-ID: <BANLkTimjOA2LiR7uy+jsHMtkMuovGuGaBQ@mail.gmail.com>
Subject: PROBLEM: unable to enumerate USB device on port 6
From: =?ISO-8859-1?Q?Franco_Gast=F3n_Pellegrini?= 
	<francogpellegrini@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel version: 2.6.38-8-generic #42-Ubuntu SMP Mon Apr 11 03:31:24
UTC 2011 x86_64 x86_64 x86_64 GNU/Linux

hi,
I have an ACER 5520, with ubuntu 11.04 and all my TTY repeats
indefinitly (every 1/3 seconds) the mesages:

.....
May 1 18:34:27 franco-Aspire-5520 kernel: [ 888.350128] hub 1-0:1.0:
unable to enumerate USB device on port 6
May 1 18:34:27 franco-Aspire-5520 kernel: [ 888.610230] hub 3-0:1.0:
unable to enumerate USB device on port 6
May 1 18:34:27 franco-Aspire-5520 kernel: [ 888.890098] hub 1-0:1.0:
unable to enumerate USB device on port 6
May 1 18:34:28 franco-Aspire-5520 kernel: [ 889.150111] hub 3-0:1.0:
unable to enumerate USB device on port 6
....

i cant use any TTY, how can i fix it? any kernel before do this for me.

PD: what info do you need to complete my report?

Excuse my english
