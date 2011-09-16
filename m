Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862Ab1IPHfy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 03:35:54 -0400
Received: from smtprelay05.ispgateway.de ([80.67.31.94]:44749 "EHLO
	smtprelay05.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753391Ab1IPHfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 03:35:53 -0400
Message-ID: <4E72FC55.1000909@ladisch.de>
Date: Fri, 16 Sep 2011 09:35:49 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: David Miller <davemiller2222@googlemail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: legal question regarding use of glibc headers in /usr/include/linux
References: <CA+o4b4fpXtF+LgLREPdjY7N06vwhCdOwRWgn-sQZYhL44=w+zA@mail.gmail.com>
In-Reply-To: <CA+o4b4fpXtF+LgLREPdjY7N06vwhCdOwRWgn-sQZYhL44=w+zA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: bGludXgta2VybmVsQGNsLmRvbWFpbmZhY3Rvcnkta3VuZGUuZGU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> ... some linux kernel headers in /usr/include/linux.
> My question now is: Can I include these headers (e.g. #include
> <linux/types.h>) since they seem to be normal glibc headers that seem
> to be intended to be included in user-space programs that are
> proprietary.

Read the clarification that Linus prepended to the COPYING file in the
kernel tree.


Regards,
Clemens
