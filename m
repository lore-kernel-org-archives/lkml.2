Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267Ab0HZTlU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 15:41:20 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:51754 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753295Ab0HZTlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 15:41:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=eOYcsOARXe9n2JyQJcu9+sO2AYwL5uvII6rpyMRRkXYAjZasczipNV1uYCyW/FvVeQ
         m69U7wb6eZJRucBmqNzJeTMJYYAvkkEKI0G6ygoffflQkbJXf6fMUdaqiRjy7mrfXrIc
         f/8drEEohV7tqb8vp3q6sG/ifnMFoMKigKEFE=
MIME-Version: 1.0
In-Reply-To: <20100826141126.11132.71843.stgit@warthog.procyon.org.uk>
References: <20100826141110.11132.91931.stgit@warthog.procyon.org.uk> <20100826141126.11132.71843.stgit@warthog.procyon.org.uk>
From: Mike Frysinger <vapier@gentoo.org>
Date: Thu, 26 Aug 2010 15:40:24 -0400
X-Google-Sender-Auth: mKirQ9X6vJvK62p1TqW81pCHUos
Message-ID: <AANLkTi=3EzXm4qu+cVLj0gapDUUWgM-V1quA6X84_jHS@mail.gmail.com>
Subject: Re: [Uclinux-dist-devel] [PATCH 4/7] Blackfin: Rename DES PC2()
 symbol to avoid collision
To: David Howells <dhowells@redhat.com>
Cc: linux-arch@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 26, 2010 at 10:11, David Howells wrote:
> Rename the PC2() symbol in the generic DES crypto module to be prefixed with
> DES_ to avoid collision with arch code (Blackfin in this case).

unfortunately this is one Blackfin define we cant easily hide away in
a peripheral-specific header and avoid global namespace pollution.  it
represents a pin that can be used across different peripherals.

so it'd be nice if the crypto/ guys took this change :)

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
-mike
