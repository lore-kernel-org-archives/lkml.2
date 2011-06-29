Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757468Ab1F2UCH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 16:02:07 -0400
Received: from mga03.intel.com ([143.182.124.21]:23215 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752849Ab1F2UCF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 16:02:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,445,1304319600"; 
   d="scan'208";a="20504197"
From: Andi Kleen <andi@firstfloor.org>
To: johnlinn@comcast.net
Cc: linux-kernel@vger.kernel.org
Subject: Re: using a single sysfs show function for multiple device attributes
References: <409519530.22419.1309373631423.JavaMail.root@sz0140a.emeryville.ca.mail.comcast.net>
Date: Wed, 29 Jun 2011 13:00:35 -0700
In-Reply-To: <409519530.22419.1309373631423.JavaMail.root@sz0140a.emeryville.ca.mail.comcast.net>
	(johnlinn@comcast.net's message of "Wed, 29 Jun 2011 18:53:51 +0000
	(UTC)")
Message-ID: <m239is2ysc.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

johnlinn@comcast.net writes:
>
> I'm sure it's obvious, but I don't see what I'm doing wrong.

The standard way is to define your own attribute structure that
has the standard attribute as the first entry and use container_of()
to get at the "parent" object.

(basically poor man's OO inheritance)

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
