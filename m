Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771Ab2DNKML (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 06:12:11 -0400
Received: from www17.your-server.de ([213.133.104.17]:53253 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011Ab2DNKMJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 06:12:09 -0400
Message-ID: <1334398320.1431.31.camel@localhost.localdomain>
Subject: Re: where can I find powertop sorces?
From: Thomas Meyer <thomas@m3y3r.de>
To: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Cc: Arjan van de Ven <arjan@linux.intel.com>, discuss <discuss@lesswatts.org>,
        Powertop Mailing List <power@bughost.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Sat, 14 Apr 2012 12:12:00 +0200
In-Reply-To: <4F89304F.1070406@freemail.hu>
References: <4F89304F.1070406@freemail.hu>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-2.fc16) 
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, den 14.04.2012, 10:07 +0200 schrieb Németh Márton:
> Hi,

hi,

> 
> I'm having trouble to fetch powertop sources. I found the article
> titled "Announcing the beta release of PowerTOP 2.0" from January 5 2011
> at http://lwn.net/Articles/421733/ but it seems that the links are not
> working anymore:
> 
> $ git clone git://git.kernel.org/pub/scm/status/powertop/powertop.git
> Cloning into powertop...
> warning: You appear to have cloned an empty repository.
> $ wget http://www.kernel.org/pub/linux/status/powertop/powertop-1.97.tar.bz2
> --2012-04-14 10:04:55--  http://www.kernel.org/pub/linux/status/powertop/powertop-1.97.tar.bz2
> Resolving www.kernel.org... 149.20.20.133, 149.20.4.69
> Connecting to www.kernel.org|149.20.20.133|:80... connected.
> HTTP request sent, awaiting response... 403 Forbidden
> 2012-04-14 10:04:56 ERROR 403: Forbidden.

http://www.mail-archive.com/power@bughost.org/msg02155.html

The repository is at https://github.com/fenrus75/powertop or
git://github.com/fenrus75/powertop.git

with kind regards
thomas



