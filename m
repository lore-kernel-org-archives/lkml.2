Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825Ab1GLSfO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 14:35:14 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:52842 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072Ab1GLSfM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 14:35:12 -0400
MIME-Version: 1.0
In-Reply-To: <CACqU3MVZ6UPZKSsSSjZosTYfbzuwj_dCumK-wcb_SWhs+8OgNQ@mail.gmail.com>
References: <CACqU3MW=VUn64nsSA2V_eXEfEjv6xmB9yBWL8rYynH1wkHcOgw@mail.gmail.com>
	<1310454020-15426-1-git-send-email-abogani@kernel.org>
	<CAFziu1HvspbMj8LRLHd2w9vcVq_mGCL3pCOwLaduKQ4nt8+Utg@mail.gmail.com>
	<CACqU3MVZ6UPZKSsSSjZosTYfbzuwj_dCumK-wcb_SWhs+8OgNQ@mail.gmail.com>
Date: Tue, 12 Jul 2011 14:35:11 -0400
Message-ID: <CAFziu1EYYN6imDijo7E_raOfdXfWAMzfJL5OursSBAYk8Wdywg@mail.gmail.com>
Subject: Re: [PATCH] modpost: Fix modpost's license checking V2
From: Anders Kaseorg <andersk@ksplice.com>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Alessio Igor Bogani <abogani@kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Jan Beulich <jbeulich@novell.com>,
        Kbuild <linux-kbuild@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Tim Bird <tim.bird@am.sony.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 12, 2011 at 14:15, Arnaud Lacombe <lacombar@gmail.com> wrote:
> modpost is an host tool, it should not include kernel header. Content
> of this file is not exported to userland anyway.

My point was more that you might as well reuse the same name and
probably the same code so that people don’t have to look carefully at
a new macro to decide whether it’s off-by-one from what they expect.

Anders
