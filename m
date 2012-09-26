Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756721Ab2IZOiG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 10:38:06 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:34786 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755926Ab2IZOiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 10:38:04 -0400
Message-ID: <50631344.2060606@openvz.org>
Date: Wed, 26 Sep 2012 18:37:56 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.7) Gecko/20120831 Firefox/10.0.7 Iceape/2.7.7
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
Subject: [bug report x86] test_nx.ko is broken
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

test_nx.ko incompatible with x86 relative exception table,
which was added in commit 706276543b699d80f546e45f8b12574e7b18d952

also it conflicts with CONFIG_DEBUG_SET_MODULE_RONX=y, because it
wants to modify write-protected data.
