Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455Ab1JAW1S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 18:27:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42983 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751309Ab1JAW1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 18:27:13 -0400
Message-ID: <4E8793B6.8030405@zytor.com>
Date: Sat, 01 Oct 2011 15:27:02 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>
Subject: Re: kernel.org status: establishing a PGP web of trust
References: <4E8655CD.90107@zytor.com> <201110012333.55428.rjw@sisk.pl>
In-Reply-To: <201110012333.55428.rjw@sisk.pl>
X-Enigmail-Version: 1.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2011 02:33 PM, Rafael J. Wysocki wrote:
> 
> OK, how long should the new key be valid?
> 

That is a good question.  At the very least you want it to be valid for
long enough that you will be able to get enough signatures on a new key
*before* your old key expires.  As such I would recommend 3-5 years
depending on how much you trust yourself to keep the key secure.

Some people have decided to opt for an unlimited key, but that
*requires* that you have a way to revoke the old key, which is why we
are considering a key revocation escrow service.

	-hpa
