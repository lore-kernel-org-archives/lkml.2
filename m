Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757743Ab0I0XqO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 19:46:14 -0400
Received: from tundra.namei.org ([65.99.196.166]:56612 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752356Ab0I0XqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 19:46:12 -0400
Date: Tue, 28 Sep 2010 09:45:41 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Eric Paris <eparis@redhat.com>
cc: Paul Moore <paul.moore@hp.com>, linux-kernel@vger.kernel.org,
        selinux@tycho.nsa.gov, netfilter-devel@vger.kernel.org,
        sds@tycho.nsa.gov, jengelh@medozas.de, casey@schaufler-ca.com,
        linux-security-module@vger.kernel.org, netfilter@vger.kernel.org,
        mr.dash.four@googlemail.com
Subject: Re: [PATCH 3/6] secmark: export binary yes/no rather than kernel
 internal secid
In-Reply-To: <1285615525.2815.76.camel@localhost.localdomain>
Message-ID: <alpine.LRH.2.00.1009280944030.2972@tundra.namei.org>
References: <20100924204517.28355.42822.stgit@paris.rdu.redhat.com>  <20100924204531.28355.20320.stgit@paris.rdu.redhat.com>  <alpine.LRH.2.00.1009271038280.25748@tundra.namei.org>  <1285606896.2815.36.camel@localhost.localdomain>  <1285612156.4935.16.camel@sifl>
 <1285615525.2815.76.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Sep 2010, Eric Paris wrote:

> James, if you are adamant about #1 I'll resend, otherwise I'm sticking
> with #3.....

Looks like #3 it is.


-- 
James Morris
<jmorris@namei.org>
