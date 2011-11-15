Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932210Ab1KOUEa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 15:04:30 -0500
Received: from caiajhbdccac.dreamhost.com ([208.97.132.202]:42188 "EHLO
	homiemail-a4.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932077Ab1KOUE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 15:04:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=jidanni.org; h=from:to:cc:subject
	:references:date:message-id:mime-version:content-type; q=dns; s=
	jidanni.org; b=lPZYHCGQIbPinH/+1xiY+vLSsBRmYixj/ETv2LhZRJZEJkDyn
	RdncU7P92pkqUttE9bred7a4yPbmW8xV/tMAzc+SPqzXtGbKleMCqnJcb/tHyKQA
	/oUhetA2xhy8xWOJr+nFNbqC93fmsv6Rz2B964RkDXHE+71BZ6UJS13iqw=
From: jidanni@jidanni.org
To: rdunlap@xenotime.net
Cc: linux-kernel@vger.kernel.org
Subject: Re: Documentation/input/input.txt.gz has a bug
References: <4EC2BEF6.7070906@xenotime.net>
Date: Wed, 16 Nov 2011 04:04:24 +0800
Message-ID: <87ty655f07.fsf@jidanni.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "RD" == Randy Dunlap <rdunlap@xenotime.net> writes:
RD>   Doing a
RD> $ cat /dev/input/mouse
RD> (which is char device 13,32) will verify that a mouse is also
RD> emulated; characters should appear if you move it.
Looks great. Thanks!
RD> Do you want to submit a patch?
Please do it for me, as it's only a 1.5 per lifetime thing. Thanks.
