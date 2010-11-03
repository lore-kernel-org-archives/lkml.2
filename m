Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186Ab0KCFHF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 01:07:05 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:18655 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719Ab0KCFHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 01:07:02 -0400
Message-ID: <4CD0EDB3.8030901@kernel.org>
Date: Tue, 02 Nov 2010 22:05:55 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.14) Gecko/20101013 SUSE/3.0.9 Thunderbird/3.0.9
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Debug patches for memblock
References: <4CAA4DC1.6000104@kernel.org> <4CACFDAD.3090900@goop.org> <4CACFECD.3090304@kernel.org> <4CACFF66.5080609@zytor.com> <4CAE121E.4080607@goop.org>
In-Reply-To: <4CAE121E.4080607@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy,

Please check some debug patches for memblock in

git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-2.6-yinghai.git memblock

hope you can use them to find out causes for some xen failure.

Thanks

	Yinghai
