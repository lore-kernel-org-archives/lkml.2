Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756300Ab0J0Tqb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 15:46:31 -0400
Received: from usmamail.tilera.com ([72.1.168.231]:55920 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949Ab0J0Tq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 15:46:29 -0400
Message-ID: <4CC88193.8020607@tilera.com>
Date: Wed, 27 Oct 2010 15:46:27 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.11) Gecko/20101013 Thunderbird/3.1.5
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH] drivers/char/hvc_console.c: reduce max idle timeout
References: <201010271659.o9RGxrMc009847@farm-0002.internal.tilera.com> <20101027202101.226085c1@lxorguk.ukuu.org.uk>
In-Reply-To: <20101027202101.226085c1@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2010 3:21 PM, Alan Cox wrote:
> On Wed, 27 Oct 2010 12:54:27 -0400 Chris Metcalf <cmetcalf@tilera.com> wrote:
>> The tile architecture uses this framework for our serial console,
> That may be a mistake unless your console is genuinely only capable of
> polled input.

The console is in fact interrupt-driven within the hypervisor, and data is
buffered there.  However, the current hypervisor console API is only
"write" and "read".  We have a bugzilla to add console interrupts to the
hypervisor API and use them from Linux, but we haven't done it yet.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

