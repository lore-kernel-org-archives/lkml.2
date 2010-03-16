Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937419Ab0CPCcl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 22:32:41 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:45467 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937358Ab0CPCcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 22:32:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=eg82HKd0DYnv/Of3yjsoMhzJ9lw0F0xf0H5tQJEZ4DObNLNwI3dH96KaB64OOa4Hpa
         guGF11uQgInB7hB+Ya5MHjTsjLrFgs7P9EPCS+kEiMEiWOSVIVH9PmQ1omXo0u9tDuYA
         kXUpE9MJBFUMlvbO2jNv7HnLMMaqkljnEQ6iA=
Message-ID: <4B9EEDBB.7030106@gmail.com>
Date: Tue, 16 Mar 2010 11:32:27 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Denys Vlasenko <vda.linux@googlemail.com>
CC: Arnd Bergmann <arnd@arndb.de>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Daniel Taylor <Daniel.Taylor@wdc.com>, Jeff Garzik <jeff@garzik.org>,
       Mark Lord <kernel@teksavvy.com>, tytso@mit.edu,
       "H. Peter Anvin" <hpa@zytor.com>, hirofumi@mail.parknet.co.jp,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, irtiger@gmail.com,
       Matthew Wilcox <matthew@wil.cx>, aschnell@suse.de, knikanth@suse.de,
       jdelvare@suse.de
Subject: Re: ATA 4 KiB sector issues.
References: <4B947393.2050002@kernel.org> <201003100046.24695.arnd@arndb.de> <1158166a1003100114j6ea329fbh84bfad65dcac90bf@mail.gmail.com> <4B9EED55.10201@kernel.org>
In-Reply-To: <4B9EED55.10201@kernel.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aieee... critical typo.

On 03/16/2010 11:30 AM, Tejun Heo wrote:
> partition table which some BIOSs actually try to do.  The problem is
> that to determine the two parameters you need to equations matching
                                                ^^
                                                two
> CHSs and LBAs

-- 
tejun
