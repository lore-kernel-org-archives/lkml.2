Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932682Ab1BWUyc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 15:54:32 -0500
Received: from usmamail.tilera.com ([206.83.70.70]:59665 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755801Ab1BWUyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 15:54:31 -0500
Message-ID: <4D657405.3050105@tilera.com>
Date: Wed, 23 Feb 2011 15:54:29 -0500
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 0/3] tile: Cleanup irq chips and irq_desc accessors
References: <20110206230305.461141290@linutronix.de>
In-Reply-To: <20110206230305.461141290@linutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/6/2011 6:04 PM, Thomas Gleixner wrote:
> Convert the irq chips to the new callback functions and use proper
> accessors for irq_desc. Select GENERIC_HARDIRQS_NO_DEPRECATED

For the series:

Acked-by: Chris Metcalf <cmetcalf@tilera.com>

Sorry for the late response, but your email came while I was still trying
to catch up with my email from a week's vacation, and I'm just re-triaging
my inbox now :-)

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

