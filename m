Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756619Ab0GHMXo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 08:23:44 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:51228 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754969Ab0GHMXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 08:23:42 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Boaz Harrosh <openosd@gmail.com>
Subject: Re: [PATCH 16/18] llseek: automatically add .llseek fop
Date: Thu, 8 Jul 2010 14:23:34 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, John Kacur <jkacur@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Christoph Hellwig <hch@lst.de>, Julia Lawall <julia@diku.dk>,
       Christoph Hellwig <hch@infradead.org>
References: <1278538820-1392-1-git-send-email-arnd@arndb.de> <1278538820-1392-17-git-send-email-arnd@arndb.de> <4C35C1F6.70902@gmail.com>
In-Reply-To: <4C35C1F6.70902@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201007081423.34877.arnd@arndb.de>
X-Provags-ID: V02:K0:PQRtgbgcwsARi+hYap9z0ooPxsidX1205gbp3aSbFzj
 jRjZoY6a9lkjUj+zfihCEcN8qmLLs+qF4EYpEHDPiecCeCBvVB
 G/5gcxz/QDI9T7YdtE6z7KYy13i+AaB0FADP6NFgIOuxIYBJ6r
 kMfcjotsJssQzw45OxoMjq6g48jevlIku9Ko+A7IWnW864Eqqz
 wSbrPpvXpw6SX/nAlC6Mw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 July 2010, Boaz Harrosh wrote:
> On 07/08/2010 12:40 AM, Arnd Bergmann wrote:
> > 
> > This specific posted version of the patch only
> > covers first few files in order to avoid
> > spamming everybody's inbox. I think you still
> > get the point. The diffstat is complete, and
> > the full patch is available in the 'llseek'
> > branch of
> > git://git.kernel.org/pub/scm/linux/kernel/git/arnd/bkl.git
> > 
> <snip>
> 
> I only got up to here in the email. (See ml sig below)
> Do you have this on git or better gitweb somewhere?

Yes. I was afraid people might reply the patch and quote the
entire 500kb email without cutting the bits they haven't actually
read ;-)

FWIW, you can get the whole patch from
http://git.kernel.org/?p=linux/kernel/git/arnd/bkl.git;a=patch;h=dc731e01d2a08eb66ae08c226c97aa0cb8cf7b7f

	Arnd
