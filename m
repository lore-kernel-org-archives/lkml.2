Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755108Ab2CVRRi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 13:17:38 -0400
Received: from gate.crashing.org ([63.228.1.57]:40237 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754038Ab2CVRRf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 13:17:35 -0400
Subject: Re: [PATCH 00/17] Platform Facilities Option and crypto accelerator driver
Mime-Version: 1.0 (Apple Message framework v1257)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <1332365297.3858.5.camel@key-ThinkPad-W510>
Date: Thu, 22 Mar 2012 12:17:08 -0500
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        rcj@linux.vnet.ibm.com, benh@kernel.crashing.org,
        linuxppc-dev@lists.ozlabs.org
Content-Transfer-Encoding: 8BIT
Message-Id: <C23F031B-1431-4E98-92DC-3EB7E31D2776@kernel.crashing.org>
References: <1332365297.3858.5.camel@key-ThinkPad-W510>
To: Kent Yoder <key@linux.vnet.ibm.com>
X-Mailer: Apple Mail (2.1257)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 21, 2012, at 4:28 PM, Kent Yoder wrote:

> arch/powerpc/crypto/nx/Makefile             |   11 +
> arch/powerpc/crypto/nx/nx-aes-cbc.c         |  135 +++++
> arch/powerpc/crypto/nx/nx-aes-ccm.c         |  466 ++++++++++++++++++
> arch/powerpc/crypto/nx/nx-aes-ctr.c         |  175 +++++++
> arch/powerpc/crypto/nx/nx-aes-ecb.c         |  133 +++++
> arch/powerpc/crypto/nx/nx-aes-gcm.c         |  352 +++++++++++++
> arch/powerpc/crypto/nx/nx-aes-xcbc.c        |  230 +++++++++
> arch/powerpc/crypto/nx/nx-sha256.c          |  240 +++++++++
> arch/powerpc/crypto/nx/nx-sha512.c          |  259 ++++++++++
> arch/powerpc/crypto/nx/nx.c                 |  710 +++++++++++++++++++++++++++
> arch/powerpc/crypto/nx/nx.h                 |  190 +++++++
> arch/powerpc/crypto/nx/nx_csbcpb.h          |  246 +++++++++
> arch/powerpc/crypto/nx/nx_sysfs.c           |  194 ++++++++

Is there a reason this isn't in drivers/crypto/

- k