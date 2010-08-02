Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975Ab0HBGoa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 02:44:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61151 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752493Ab0HBGo2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 02:44:28 -0400
Message-ID: <4C566942.9020608@redhat.com>
Date: Mon, 02 Aug 2010 08:44:18 +0200
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.7) Gecko/20100713 Lightning/1.0b2 Thunderbird/3.1.1
MIME-Version: 1.0
To: Alasdair G Kergon <agk@redhat.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the device-mapper tree
References: <20100802113148.e0b70b34.sfr@canb.auug.org.au>
In-Reply-To: <20100802113148.e0b70b34.sfr@canb.auug.org.au>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2010 03:31 AM, Stephen Rothwell wrote:
> After merging the device-mapper tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> drivers/md/dm-crypt.c: In function 'crypt_ctr_cipher':
> drivers/md/dm-crypt.c:1095: error: 'bad_mem' undeclared (first use in this function)

hmmmm, Alasdair you edited that patch?
The version I sent compiled cleanly.
(moreover it is just part of patchset which is not yet fully there, seems)

Milan
