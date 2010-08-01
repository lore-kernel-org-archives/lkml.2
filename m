Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162Ab0HAMKm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 08:10:42 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:62203 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847Ab0HAMKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 08:10:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:content-type;
        b=exFxVuCPjCL75xhbfSJWkBUTACQkgTjYoKMYhQMnCTvPTOX5AAnpVFSwuQpY4vaHTE
         3HOpmh9xWJJ/7DPgr4Z9gQBnyqbJQbkfZ2+iXU+swbIg6zU43fREJWnVwvIL93vfXA9Q
         y/Q3wmNnkmIzrlMX39UB/P6EMlJpv8lyQEAEg=
MIME-Version: 1.0
Date: Sun, 1 Aug 2010 15:10:40 +0300
X-Google-Sender-Auth: -mP-5oH6rpjhfQBhhS9twYveSbQ
Message-ID: <AANLkTiksVFpU+3iek4-TM2q=wSDGpW_nJAr8XtHT06LE@mail.gmail.com>
Subject: Boot-time dynamic debugging?
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Jason Baron <jbaron@redhat.com>, Greg KH <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Commit 346e15beb5343c2eb8216d820f2ed8f150822b08 ("driver core: basic
infrastructure for per-module dynamic debug messages") removed
"dynamic_printk" kernel parameter from the dynamic debugging subsystem
(and forgot to update Documentation/kernel-parameters.txt). How can I
use the new subsystem for enabling boot-time dev_dbg() calls for
non-modular kernels?

                        Pekka
