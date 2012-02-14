Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641Ab2BNPWx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 10:22:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27762 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751329Ab2BNPWv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 10:22:51 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <4F3A785A.4030500@de.ibm.com>
References: <4F3A785A.4030500@de.ibm.com> <20120214145022.12531.16731.stgit@warthog.procyon.org.uk>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: dhowells@redhat.com, keyrings@linux-nfs.org, linux-kernel@vger.kernel.org,
        dan@danny.cz, Carsten Otte <cotte@de.ibm.com>,
        linux-s390@vger.kernel.org, stable@vger.kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH] KEYS: Enable the compat keyctl wrapper on s390x
Date: Tue, 14 Feb 2012 15:22:38 +0000
Message-ID: <15313.1329232958@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> Do you want to push this change via Martins s390 tree or via other
> trees?

I've no objection to it going via Martin's tree.  It's really an S390 fix
rather than a keyrings/security fix.

David
