Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759109Ab0HLO6U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 10:58:20 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:40093 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386Ab0HLO6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 10:58:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:content-type;
        b=VjCUuCgNSM3X47xG0N96GVhcN3lUiMtTdzHnfRohTXrRsl4vNKqS8/ZS2N6YRhzCn1
         vbH16Dt7zxplQKJ/rYLCEPBHjuyCEs1mGaSNWlFw//jQ+wKKaP2e+Gxld4O5iBu5AUcD
         4oG0jFvNuYtkj/W6Hcdbx1DgIMqY43gsLgIVU=
MIME-Version: 1.0
Date: Thu, 12 Aug 2010 16:58:13 +0200
X-Google-Sender-Auth: H285OS-eTtK_4OSRAHgsFiC7C9o
Message-ID: <AANLkTikK5m_DE_bzcuiqOpoSVqFzUp=GeD5k01foop=E@mail.gmail.com>
Subject: [ANNOUNCE][UNOFFICIAL] 2.6.33.8
From: John Kacur <jkacur@redhat.com>
To: LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are no longer any official 2.6.33 stable releases after 2.6.33.7
However, 2.6.33.y is the basis for the real-time kernel.
So, I went through the changes from 2.6.32.17->2.6.32.18
and from 2.6.34.2->2.6.34.3
and cherry picked the ones that I thought applied to 2.6.33.7 in order
to create my own unofficial stable update 2.6.33.8

Testing has been very limited, just make allyesconfig and
allmodconfig, and then booting on my personal machine,
so use with caution. However, I am happy to share my results with
anyone who is interested.

You can pull the git tree here.
git://git.kernel.org/pub/scm/linux/kernel/git/jkacur/jk-2.6.git
branch: stable/linux-2.6.33.y

I will continue to do this as long as it is still useful for -rt, and
share the results with everyone.

Thanks
