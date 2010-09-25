Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258Ab0IYIso (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 04:48:44 -0400
Received: from mail.us.es ([193.147.175.20]:41249 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751083Ab0IYIsn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 04:48:43 -0400
Message-ID: <4C9DB5CE.7090305@netfilter.org>
Date: Sat, 25 Sep 2010 10:41:50 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100619 Icedove/3.0.5
MIME-Version: 1.0
To: Eric Paris <eparis@redhat.com>
CC: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
        netfilter-devel@vger.kernel.org, jmorris@namei.org, sds@tycho.nsa.gov,
        jengelh@medozas.de, paul.moore@hp.com, casey@schaufler-ca.com,
        linux-security-module@vger.kernel.org, netfilter@vger.kernel.org,
        mr.dash.four@googlemail.com
Subject: Re: [PATCH 3/6] secmark: export binary yes/no rather than kernel
 internal	secid
References: <20100924204517.28355.42822.stgit@paris.rdu.redhat.com> <20100924204531.28355.20320.stgit@paris.rdu.redhat.com>
In-Reply-To: <20100924204531.28355.20320.stgit@paris.rdu.redhat.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/09/10 22:45, Eric Paris wrote:
> Currently the nfconntrack export code sends the kernel internal secid to
> userspace in a couple of proc files and over netlink as an integer.  This
> is wrong.  This number is a kernel internal.  This patch changes the export
> code to output either 0 or 1 for this value.  A future patch will implement
> sending the name rather than the number in a new field.

I'm not sure why you need this transitional patch if you later on
replace it.

Better to change the /proc output to make it consistent with patch 5/6?
