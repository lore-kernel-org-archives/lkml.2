Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932433Ab0JANUv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 09:20:51 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:44337 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932088Ab0JANUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 09:20:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=DZW2vjUAacpgb6T8f8OEG9s8iigMU8CkLFzwSawLwEASt2fhqTKWYBQglRYw1Nnv/Q
         jWooHot8YefaB00CDwQlP8SSB+xiPUziHTAhVpaWN6CIOn7M1F89hC87ZaJtKwD5O13p
         DOdBFy2RrNfOVg3VAkXRJlfaaAeCJPuLLPUc8=
Date: Fri, 1 Oct 2010 17:20:45 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alan Cox <alan@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>,
        Tobias Klauser <tklauser@distanz.ch>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/8] Some patches for Altera UART driver
Message-ID: <20101001132045.GA9649@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is v2. Changes:

- Addressed comments by Alan Cox and Tobias Klauser;
- In patch 'Add support for getting mapbase and IRQ from resources',
  added ioremap() return value checking;
- Added a few fixup patches.

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
