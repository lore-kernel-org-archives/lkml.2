Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343Ab1JGEgT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 00:36:19 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:50434 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249Ab1JGEgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 00:36:18 -0400
X-AuditID: b753bd60-a0885ba000000655-4c-4e8e81bff5fb
X-AuditID: b753bd60-a0885ba000000655-4c-4e8e81bff5fb
Message-ID: <4E8E81AC.4090306@hitachi.com>
Date: Fri, 07 Oct 2011 13:35:56 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Josh Stone <jistone@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, "hpanvin@gmail.com" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Jakub Jelinek <jakub@redhat.com>
Subject: Re: [PATCH] x86: Make variable_test_bit reference all of *addr
References: <1317945508-19575-1-git-send-email-jistone@redhat.com> <990b8719-066b-4e1d-892f-6a3ea4241fb2@email.android.com> <m2d3e936fn.fsf@firstfloor.org> <4E8E690C.9010206@redhat.com>
In-Reply-To: <4E8E690C.9010206@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Josh,

Thank you for reporting details :)

(2011/10/07 11:50), Josh Stone wrote:
> We can make twobyte_is_boostable[] volatile instead, which does the
> trick, but that seems a kludge to me.

I think this time we'd better to do this (with comments),
since this may not affect most of bitmap users using it for
checking dynamically allocated bit-flags. kprobe's bitmap
usage seems a special case.

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
