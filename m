Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756626Ab1GMQlH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 12:41:07 -0400
Received: from smtpo.poczta.interia.pl ([217.74.65.205]:43316 "EHLO
	smtpo.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756215Ab1GMQlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 12:41:06 -0400
Message-ID: <4E1DCA76.7090809@interia.pl>
Date: Wed, 13 Jul 2011 17:40:22 +0100
From: =?UTF-8?b?UmFmYcWC?= Bilski <rafalbilski@interia.pl>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:5.0) Gecko/20110628
	Thunderbird/5.0
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Axel Lin <axel.lin@gmail.com>,
        linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Subject: Re: [PATCH] e_powersaver: Underclock checks
References: <1310114243.2940.3.camel@phoenix> <4E1B745A.5000802@interia.pl>
	<4E1B8404.1050909@interia.pl> <20110711232517.GC20367@redhat.com>
	<4E1C7D96.1030500@interia.pl>
In-Reply-To: <4E1C7D96.1030500@interia.pl>
X-Interia-Antivirus: OK
X-EMID: a7a5b958
Content-Type: text/plain; charset="UTF-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Some systems are using 1.2GHz@844mV processors running at 600MHz@796mV.
OK. That's strange. It is 1,2GHz system. Can both ACPI p-states and "e_powersaver"
drivers be running at the same time? Can BIOS change processor frequencies without
Linux knowing and without p-states driver loaded?
I can't test system in question. I will try to buy something similar to test it.

Thank you
Rafał Bilski


----------------------------------------------------------------
Dom marzen - kup lub wynajmij taniej niz myslisz!
Szukaj >> http://linkint.pl/f29e5
