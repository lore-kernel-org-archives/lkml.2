Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758181Ab2CVURd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 16:17:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34773 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756652Ab2CVUR2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 16:17:28 -0400
Message-ID: <4F6B88D2.5060500@redhat.com>
Date: Thu, 22 Mar 2012 17:17:22 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for Mar 22
References: <20120322170829.38a649b3f84d225d94808648@canb.auug.org.au>
In-Reply-To: <20120322170829.38a649b3f84d225d94808648@canb.auug.org.au>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,


Em 22-03-2012 03:08, Stephen Rothwell escreveu:
> Merging edac/linux_next (4d096ca MAINTAINERS: add an entry for Edac Sandy Bridge driver)

Not sure what's happening, but I've updated my EDAC tree a few days ago,
and I've added more stuff yesterday, but you're still pointing to an
old changeset.

Could you please check if it is pointing to the right tree/branch? It should be:

	git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-edac.git linux-next

Thanks!
Mauro
