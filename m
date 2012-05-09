Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756326Ab2EIOvR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 10:51:17 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19218 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754274Ab2EIOvP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 10:51:15 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 09 May 2012 07:50:27 -0700
From: Rhyland Klein <rklein@nvidia.com>
To: "'Nikolaus Voss'" <n.voss@weinmann.de>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
CC: "'cbouatmailru@gmail.com'" <cbouatmailru@gmail.com>
Date: Wed, 9 May 2012 07:51:05 -0700
Subject: RE: [PATCH] drivers/power/sbs-battery.c: don't trigger false
 supply_changed event
Thread-Topic: [PATCH] drivers/power/sbs-battery.c: don't trigger false
 supply_changed event
Thread-Index: Ac0tulHwbTWWluBPSQKHlCREdIYs2wAOJChA
Message-ID: <2C89F4165782854891CDE0F3198B753C14F523E30A@HQMAIL01.nvidia.com>
References: <201205090803.q4983lYa013593@gatekeeper.vosshq.de>
In-Reply-To: <201205090803.q4983lYa013593@gatekeeper.vosshq.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-09 at 2:31, Nikolaus Voss wrote:
>power_supply_changed() events are triggerd based on the return value
>of a get_property() call. However the property TECHNOLOGY is
>hard-coded to LION in this driver, thus always succeeds.
>
>So, with the battery removed, this triggers a false battery present
>uevent. This uevent triggers a new query via power_supply_uevent()
>which again starts to query all known properties and thus leads to
>an infinite loop of battery present/not-present uevents.
>
>This patch skips the battery presence detection for the hard-coded
>property TECHNOLOGY.
>
>Signed-off-by: Nikolaus Voss <n.voss@weinmann.de>

Acked-by Rhyland Klein <rklein@nvidia.com>

--
nvpublic
