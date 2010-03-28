Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200Ab0C1ULg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 16:11:36 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:57851 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755041Ab0C1ULf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 16:11:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=owsylvdbpr6uuCZqNaRGu1YGt7bDL4c77NVUe76YGmHFtaTOZBYtFYgOBblD40CF0p
         +J576S1Btr4LZM5WcZGqvdDyHEWkDH8PCASsLw8sLZseg4tVQZMFMrj2N/O69UWzO8OZ
         1ofMHEGGPX2d622rywfcrMCJ3562xYFekFbUk=
Date: Sun, 28 Mar 2010 22:11:37 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>,
       Thomas Gleixner <tglx@linutronix.de>, jblunck@suse.de,
       Alan Cox <alan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [GIT, RFC] Killing the Big Kernel Lock
Message-ID: <20100328201136.GD5116@nowhere>
References: <201003242240.54907.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201003242240.54907.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 24, 2010 at 10:40:54PM +0100, Arnd Bergmann wrote:
> Arnd Bergmann (44):
>       input: kill BKL, fix input_open_file locking


This one is upstream now.

