Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532Ab1ATS1U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 13:27:20 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:50746 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199Ab1ATS1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 13:27:19 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Subject: Re: [PATCH 1/3] tty: move hvc drivers to drivers/tty/hvc/
Date: Thu, 20 Jan 2011 19:27:15 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37+; KDE/4.5.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <20110120174910.GA30124@kroah.com> <1295546625-30681-1-git-send-email-gregkh@suse.de>
In-Reply-To: <1295546625-30681-1-git-send-email-gregkh@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201101201927.15067.arnd@arndb.de>
X-Provags-ID: V02:K0:wJ0OY5HizrTOxK8WX57xT8JBPnK/5sk/IeFhJmDG1PM
 8lz4xFJniilQTo1p5l4CFw6tHJc4sBGPlb6yE3ePYCUJ8cPfrb
 tQsObg5UfHZowOJJZexvZGPGfJEABp+WnAO309bDKleYZY3X9u
 CtUaI9eDMzO5Lxn4/qry28drJkNovyg0ksaM8pjxWIZemPswkh
 4ycH32fsUirV3q3JhNQiw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 January 2011 19:03:43 Greg Kroah-Hartman wrote:
> 
> As requested by Arnd Bergmann, the hvc drivers are now
> moved to the drivers/tty/hvc/ directory.  The virtio_console.c driver
> was also moved, as it required the hvc_console.h file to be able to be
> built, and it really is a hvc driver.
> 
> Cc: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

Acked-by: Arnd Bergmann <arnd@arndb.de>
